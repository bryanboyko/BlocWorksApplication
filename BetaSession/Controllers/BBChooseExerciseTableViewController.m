//
//  BBChooseExerciseTableViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBChooseExerciseTableViewController.h"
#import "BBTrainingPlanTableViewController.h"
#import "BBExerciseStore.h"
#import "BBExercise.h"
#import "BBExerciseCellTableViewCell.h"
#import "BBPlan.h"
#import "BBPlanExerciseIndexPath.h"


@interface BBChooseExerciseTableViewController ()

@end

@implementation BBChooseExerciseTableViewController

- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UIBarButtonItem *doneExercise = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneExercise;
        
        UIBarButtonItem *cancelExercise = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelExercise;
        
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up tableview
    self.tableView.rowHeight = 60;
    //load nib
    UINib *nib = [UINib nibWithNibName:@"BBExerciseCellTableViewCell" bundle:nil];
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    
    
    //register nib containing cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBExerciseCellTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

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
    NSArray *exercises = [[BBExerciseStore sharedStore] allExercises];
    BBExercise *exercise = exercises[indexPath.row];
    
    //send exercise object to BBTrainingPlanTableViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseExercise" object:exercise];
    
    [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
@end
