//
//  BBPlanDetailViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPlanDetailViewController.h"
#import "BBPlan.h"
#import "BBPlanStore.h"

@interface BBPlanDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)backgroundTapped:(id)sender;

@end

@implementation BBPlanDetailViewController

- (instancetype)initForNewPlan:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *donePlan = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = donePlan;
            
            UIBarButtonItem *cancelPlan = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelPlan;
            
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
            
            [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            
            self.navigationItem.title = self.plan.planName;
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong init" reason:@"Use initForNewPlan" userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BBPlan *plan = self.plan;
    
    self.nameTextField.text = plan.planName;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    BBPlan *plan = self.plan;
    plan.planName = self.nameTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    //if user cancels, remove exercise from store
    [[BBPlanStore sharedStore] removePlan:self.plan];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

@end
