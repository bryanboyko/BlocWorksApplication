//
//  BBChooseTableViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPlan;

@interface BBChooseTableViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSDate *dateChosen;
@property (nonatomic) NSString *nameFromSelectedRow;
@property (nonatomic, strong) BBPlan *plan;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;


@end
