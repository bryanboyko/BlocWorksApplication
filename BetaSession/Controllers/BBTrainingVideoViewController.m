//
//  BBTrainingVideoViewController.m
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

#import "BBPsychVideo.h"
#import "BBPsychVideoStore.h"
#import "BBPVTableViewCell.h"
#import "BBPVWebViewController.h"



@interface BBTrainingVideoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BBTrainingVideoViewController

@synthesize menuDrawerWidth, menuDrawerX, recognizer_close, recognizer_open, menuDrawer, menuItems, mainTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        // navigation bar appearance
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor],NSForegroundColorAttributeName,
                                        [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
        
        self.navigationController.navigationBar.titleTextAttributes = textAttributes;
        self.title = @"Bookmarks";
        
        // custom navigation button
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *menuBtnImage = [UIImage imageNamed:@"list-view-32"]  ;
        [menuBtn setBackgroundImage:menuBtnImage forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(drawerAnimation) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.frame = CGRectMake(0, 0, 32, 20);
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn] ;
        self.navigationItem.leftBarButtonItem = menuButton;
   
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewPsychVideo:)];
        
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    //tableview setup
    UINib *nib = [UINib nibWithNibName:@"BBPVTableViewCell" bundle:nil];
    
    self.tableView.rowHeight = 60;
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBPVTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma tableview code

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BBPsychVideoStore sharedStore] allPsychVideos] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BBPVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBPVTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    
    
    NSArray *psychVideos = [[BBPsychVideoStore sharedStore] allPsychVideos];
    BBPsychVideo *psychVideo = psychVideos[indexPath.row];
    cell.psychVideoNameLabel.text = psychVideo.psychVideoName;
    cell.psychVideoURLLabel.text = psychVideo.psychVideoURL;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //wanted to use mpmoviewplayercontroller here, but its not possible with youtube??
    NSArray *psychVideos = [[BBPsychVideoStore sharedStore] allPsychVideos];
    BBPsychVideo *psychVideo = psychVideos[indexPath.row];
    
    NSLog(@"selected video: %@", psychVideo);
    
    BBPVWebViewController *wvc = [[BBPVWebViewController alloc] init];
    wvc.URL = psychVideo.psychVideoURL;
    
    NSLog(@"webview controller url instance: %@", wvc.URL);
    
    [self.navigationController pushViewController:wvc animated:YES];
    
}

- (IBAction)addNewPsychVideo:(id)sender
{
    BBWebViewController1 *wvc = [[BBWebViewController1 alloc] init];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    } else {
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *psychVideos = [[BBPsychVideoStore sharedStore] allPsychVideos];
        BBPsychVideo *psychVideo = psychVideos[indexPath.row];
        [[BBPsychVideoStore sharedStore] removePsychVideo:psychVideo];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
