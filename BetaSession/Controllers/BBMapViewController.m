//
//  BBMapViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "UIImage+ImageEffects.h"
#import "PDTSimpleCalendarViewController.h"
#import "BBPlanTableViewController.h"
#import "BBExerciseTableViewController.h"
#import "BBTrainingVideoViewController.h"
#import "BBMapViewController.h"

@interface BBMapViewController ()

@end

@implementation BBMapViewController

@synthesize menuDrawerWidth, menuDrawerX, recognizer_close, recognizer_open, menuDrawer, menuItems, mainTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up mapView
    
    self.mapView.delegate = self;
    
    [self.mapView setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    self.firstLaunch = YES;
    
    //set up drawer
    int statusBarHeight = 63;
    menuDrawerWidth = self.view.frame.size.width * 0.75;
    menuDrawerX = self.view.frame.origin.x - menuDrawerWidth;
    menuDrawer = [[UIView alloc] initWithFrame:CGRectMake(menuDrawerX, self.view.frame.origin.y + statusBarHeight, menuDrawerWidth, self.view.frame.size.height - statusBarHeight)];
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"TableView"];
    UIImage *darkBackground = [backgroundImage applyDarkEffect];
    menuDrawer.backgroundColor = [UIColor colorWithPatternImage:darkBackground];
    
    recognizer_close = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    recognizer_open = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    recognizer_close.direction = UISwipeGestureRecognizerDirectionLeft;
    recognizer_open.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:recognizer_open];
    [self.view addGestureRecognizer:recognizer_close];
    
    
    //set up view in drawer
    
    float originOfButtons = 37.0f;
    float buttonWidth = 227.0f;
    float buttonHeight = 50.0f;
    int buttonSeparator = 37;
    
    menuItems = [[NSArray alloc] initWithObjects:@"Calendar", @"Plans", @"Exercises", @"Bookmarks", @"Gym Locator", nil];
    for (int b = 0; b < [menuItems count]; b++) {
        UIButton *myButton = [[UIButton alloc] initWithFrame:CGRectMake(3.0f, originOfButtons, buttonWidth, buttonHeight)];
        myButton.backgroundColor = [UIColor clearColor];
        myButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [myButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [myButton setTag:b];
        [myButton setTitle:[menuItems objectAtIndex:b] forState:UIControlStateNormal];
        [myButton setSelected:NO];
        [myButton addTarget:self action:@selector(closeDrawerThenMenuSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        //add button shadow
        CALayer *textLayer = ((CALayer *)[myButton.layer.sublayers objectAtIndex:0]);
        textLayer.shadowColor = [UIColor blackColor].CGColor;
        textLayer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        textLayer.shadowOpacity = 1.0f;
        textLayer.shadowRadius = 2.0f;
        
        [menuDrawer addSubview:myButton];
        
        originOfButtons += (buttonHeight + buttonSeparator);
    }
    
    //add drawer view as subview
    [self.view addSubview:menuDrawer];
    
    //add shadow to overlying view
    CALayer *layer = self.menuDrawer.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 2.0f;
    layer.shadowOpacity = 0.70f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // navigation bar appearance
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = @"Gym Locator";
    
    // custom navigation button
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *menuBtnImage = [UIImage imageNamed:@"list-view-32"]  ;
    [menuBtn setBackgroundImage:menuBtnImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(drawerAnimation) forControlEvents:UIControlEventTouchUpInside];
    menuBtn.frame = CGRectMake(0, 0, 32, 20);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn] ;
    self.navigationItem.leftBarButtonItem = menuButton;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Google Places API and mapView Setup


- (IBAction)findClimbingNearby:(id)sender {
        [self googleAPIRequest:@"climbing"];
}

- (void)googleAPIRequest: (NSString *) googleType
{
    //build URL string to send to google
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", self.currentCenter.latitude, self.currentCenter.longitude, [NSString stringWithFormat:@"%i", self.currentDistance], googleType, kGOOGLE_API_KEY];
    
    //convert string to URL
    NSURL *googleRequestURL = [NSURL URLWithString:url];
    
    //retrieve URL results
    dispatch_async(kBgQueue, ^{NSData *data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData: (NSData *)responseData
{
    //parse JSON Data
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    
    //google JSON results in array from NSDictionary with key 'results'
    NSArray *places = [json objectForKey:@"results"];
    
    //write out the data to the console
    NSLog(@"Google Data: %@", places);
    //NSLog(@"json: %@", json);
    
    [self plotAnnotations:places];
}

#pragma MKMapViewDelegate Methods

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKCoordinateRegion region;
    
    if (self.firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 4000, 4000);
        self.firstLaunch = NO;
    } else {
        //if its not the first launch then relaunch to previous map view
        NSLog(@"sent?");
        region = MKCoordinateRegionMakeWithDistance(self.currentCenter, self.currentDistance, self.currentDistance);
    }
    
    //BUG
    //[mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //get east and west points on map to calculate current zoom
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //set currentDistance variable
    self.currentDistance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //set centerPoint variable
    self.currentCenter = self.mapView.centerCoordinate;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //define reuse id
    static NSString *identifier = @"BBMapAnnotation";
    
    if ([annotation isKindOfClass:[BBMapAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

#pragma plotting annotations

- (void)plotAnnotations:(NSArray *)data
{
    //remove existing annotations
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[BBMapAnnotation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    //add annotations
    for (int i = 0; i < [data count]; i++) {
        //retrive nsdicationary object in each index of array
        NSDictionary *place = [data objectAtIndex:i];
        NSLog(@"place: %@", place);
        //use ndicationary object for location info
        NSDictionary *geo = [place objectForKey:@"geometry"];
        //latitude and longitude
        NSDictionary *loc = [geo objectForKey:@"location"];
        //name and address (for annotation pin)
        NSString *name = [place objectForKey:@"name"];
        NSString *vicinity = [place objectForKey:@"vicinity"];
        //create variable to hold coordinate info
        CLLocationCoordinate2D placeCoordinate;
        //set lat and long
        placeCoordinate.latitude = [[loc objectForKey:@"lat"] doubleValue];
        placeCoordinate.longitude = [[loc objectForKey:@"lng"] doubleValue];
        //CREATE ANNOTATION
        BBMapAnnotation *placeAnnotation = [[BBMapAnnotation alloc] initWithName:name address:vicinity coordinate:placeCoordinate];
        [self.mapView addAnnotation:placeAnnotation];
    }
}

#pragma drawer code

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    [self drawerAnimation];
}

- (void)drawerAnimation
{
    //set up animation delegate
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    
    //drawer speed
    [UIView setAnimationDuration:-5];
    
    CGFloat new_x = 0;
    //open drawer if its closed and close if its open
    if (menuDrawer.frame.origin.x < self.view.frame.origin.x) {
        new_x = menuDrawer.frame.origin.x + menuDrawerWidth;
    } else {
        new_x = menuDrawer.frame.origin.x - menuDrawerWidth;
    }
    
    menuDrawer.frame = CGRectMake(new_x, menuDrawer.frame.origin.y, menuDrawer.frame.size.width, menuDrawer.frame.size.height);
    
    //commit animation
    [UIView commitAnimations];
    
}

- (void)closeDrawerThenMenuSelect:(id)sender
{
    [self drawerAnimation];
    switch ([sender tag]) {
        case 0:{
            [self performSelector:@selector(pushCalendar) withObject:nil afterDelay:0.3];
            break;
        }
        case 1:{
            [self performSelector:@selector(pushPlan) withObject:nil afterDelay:0.3];
            break;
        }
        case 2:{
            [self performSelector:@selector(pushExercise) withObject:nil afterDelay:0.3];
            break;
        }
        case 3:{
            [self performSelector:@selector(pushVideo) withObject:nil afterDelay:0.3];
            break;
        }
        case 4:{[self performSelector:@selector(pushMap) withObject:nil afterDelay:0.3];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)pushCalendar
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)pushPlan
{
    BBPlanTableViewController *tvc = [[BBPlanTableViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:NO];
}

- (void)pushExercise
{
    BBExerciseTableViewController *evc = [[BBExerciseTableViewController alloc] init];
    [self.navigationController pushViewController:evc animated:NO];
}

- (void)pushVideo
{
    BBTrainingVideoViewController *tvvc = [[BBTrainingVideoViewController alloc] init];
    [self.navigationController pushViewController:tvvc animated:NO];
}

- (void)pushMap
{
    BBMapViewController *mvc = [[BBMapViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:NO];
}
@end
