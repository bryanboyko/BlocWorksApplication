//
//  BBExerciseTableViewController.m
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

#import "BBExerciseCellTableViewCell.h"
#import "BBExercise.h"
#import "BBExerciseStore.h"
#import "BBDetailViewController.h"

@interface BBExerciseTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BBExerciseTableViewController

@synthesize menuDrawerWidth, menuDrawerX, recognizer_close, recognizer_open, menuDrawer, menuItems, mainTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        
                //add new exercise button
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise:)];
        navItem.rightBarButtonItem = bbi;
        navItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
    return self;
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
    
    //SET UP TABLEVIEW
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBExerciseCellTableViewCell" bundle:nil];
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBExerciseCellTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    // navigation bar appearance
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = @"Exercises";
    
    // custom navigation button
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *menuBtnImage = [UIImage imageNamed:@"list-view-32"]  ;
    [menuBtn setBackgroundImage:menuBtnImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(drawerAnimation) forControlEvents:UIControlEventTouchUpInside];
    menuBtn.frame = CGRectMake(0, 0, 32, 20);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menuBtn] ;
    self.navigationItem.leftBarButtonItem = menuButton;
    
    //tableview
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
    return [[[BBExerciseStore sharedStore] allExercises] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //get new cell
    BBExerciseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBExerciseCellTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *exercises = [[BBExerciseStore sharedStore] allExercises];
    BBExercise *exercise = exercises[indexPath.row];
    
    //fill custom cell
    cell.exerciseNameLabel.text = exercise.exerciseName;
    cell.exerciseStyleLabel.text = exercise.exerciseStyle;
    cell.imageView.image = exercise.thumbnail;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellStartEditing = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleEditingMode:)];
    
    BBDetailViewController *dvc = [[BBDetailViewController alloc] initForNewExercise:NO];
    
    NSArray *exercises = [[BBExerciseStore sharedStore] allExercises];
    BBExercise *selectedExercise = exercises[indexPath.row];
    
    dvc.exercise = selectedExercise;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)addNewExercise:(id)sender
{
    BBExercise *newExercise = [[BBExerciseStore sharedStore] createExercise];
    
    BBDetailViewController *dvc = [[BBDetailViewController alloc] initForNewExercise:YES];
    
    dvc.exercise = newExercise;
    
    dvc.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dvc];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    } else {
        [self.tableView reloadData];
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if tableview is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *exercises = [[BBExerciseStore sharedStore] allExercises];
        BBExercise *exercise = exercises[indexPath.row];
        [[BBExerciseStore sharedStore] removeExercise:exercise];
        
        //remove row with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView reloadData];
}

@end
