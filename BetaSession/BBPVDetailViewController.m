//
//  BBPVDetailViewController.m
//  Training
//
//  Created by Bryan Boyko on 5/30/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPVDetailViewController.h"
#import "BBTrainingVideoViewController.h"
#import "BBPsychVideoStore.h"
#import "BBPsychVideo.h"
#import "BBWebViewController1.h"

@interface BBPVDetailViewController () <UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *psychVideoNameTextField;

- (IBAction)backgroundTapped:(id)sender;


@end

@implementation BBPVDetailViewController

- (instancetype)initForNewPsychVideo:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            
            self.navigationItem.rightBarButtonItem = doneItem;
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            
            self.navigationItem.leftBarButtonItem = cancelItem;
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
            
            [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @ throw [NSException exceptionWithName:@"wrong initializer" reason:@"use initForNewPsychVideo" userInfo:nil];
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BBPsychVideo *psychVideo = self.psychVideo;
    

    self.psychVideoNameTextField.text = psychVideo.psychVideoName;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
//    NSURL *psychVideoURLURL = [NSURL fileURLWithPath:self.psychVideoURLTextField.text];
    

    BBPsychVideo *pv = self.psychVideo;
    pv.psychVideoName = self.psychVideoNameTextField.text;

}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[BBPsychVideoStore sharedStore] removePsychVideo:self.psychVideo];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


//- (IBAction)deleteVideo:(id)sender
//{
//    [[BBPsychVideoStore sharedStore] removePsychVideo:self.psychVideo];
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
@end

