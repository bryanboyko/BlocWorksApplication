//
//  BBTrainingPlanTableViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "UIImage+ImageEffects.h"
#import "BBTrainingPlanTableViewController.h"
#import "PDTSimpleCalendarViewController.h"
#import "BBExerciseTableViewController.h"
#import "BBTrainingVideoViewController.h"
#import "BBMapViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "BBExerciseCellTableViewCell.h"
#import "BBExercise.h"
#import "BBExerciseStore.h"
#import "BBDetailViewController.h"
#import "BBChooseExerciseTableViewController.h"
#import "BBPlanStore.h"

@interface BBTrainingPlanTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *planName;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong)MPMoviePlayerController *videoController;

@property (nonatomic) NSMutableArray *privatePlanExercises;

@end

@implementation BBTrainingPlanTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //add existing exercise button to nav bar
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExistingExercise:)];
        navItem.rightBarButtonItem = bbi;
        navItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backBtnImage = [UIImage imageNamed:@"Back"]  ;
        [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, 12, 21);
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
        self.navigationItem.leftBarButtonItem = backButton;
        
        NSLog(@"self.plan.planExerciseArray:%@", self.plan.planExerciseArray);
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerAction:) name:@"chooseExercise" object:nil];
    
    return self;
}

//method for custom nav bar
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Notification
-(void)triggerAction:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[BBExercise class]])
    {
        
        BBExercise *exercise = [notification object];
        NSLog(@"exercise received: %@", exercise);
        
        [self.plan.planExerciseArray addObject:exercise];
        NSLog(@"self.plan.planExerciseArray :%@", self.plan.planExerciseArray);
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //set up tableview
    self.tableView.rowHeight = 60;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBExerciseCellTableViewCell" bundle:nil];
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBExerciseCellTableViewCell"];
    
    self.privatePlanExercises = self.plan.planExerciseArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    // navigation bar appearance
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = self.plan.planName;
    
    //tableview
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma tableview code


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.plan.planExerciseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //get new cell
    BBExerciseCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBExerciseCellTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];

    
    NSLog(@"cell loaded");
    
    NSArray *planExercises = self.plan.planExerciseArray;
    
    NSLog(@"planExercises: %@", planExercises);
    
    BBExercise *exercise = [planExercises objectAtIndex:indexPath.row];
    
    //fill custom cell
    cell.exerciseNameLabel.text = exercise.exerciseName;
    cell.exerciseStyleLabel.text = exercise.exerciseStyle;
    cell.imageView.image = exercise.thumbnail;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellStartEditing = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleEditingMode:)];
    
    //selecting a row will play the associated video
    
    BBExercise *selectedExercise = self.plan.planExerciseArray[indexPath.row];
    
    NSLog(@"selected Exercise: %@", selectedExercise);
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    [self.videoController  setContentURL:selectedExercise.videoURL];
    [self.view addSubview:self.videoController.view];
    [self.videoController setFullscreen:YES];
    [self.videoController play];
    
    
}

- (IBAction)addExistingExercise:(id)sender
{
    BBChooseExerciseTableViewController *tvc = [[BBChooseExerciseTableViewController alloc] init];
    
    tvc.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    } else {
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if tableview is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.plan.planExerciseArray removeObjectAtIndex:indexPath.row];
        
        //remove row with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
