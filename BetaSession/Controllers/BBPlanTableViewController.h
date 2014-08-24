//
//  BBPlanTableViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBPlan.h"
#import "BBPlanStore.h"

@interface BBPlanTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UISwipeGestureRecognizer *cellStartEditing, *cellStopEditing;

#pragma DRAWER

@property (nonatomic, retain) NSArray *menuItems;
@property (strong, nonatomic) IBOutlet UILabel *mainTitle;

@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_open, *recognizer_close;
@property (readonly, nonatomic) int menuDrawerX, menuDrawerWidth;
@property (nonatomic) UIView *menuDrawer;



- (void)handleSwipes:(UISwipeGestureRecognizer *)sender;
- (void)drawerAnimation;

@end
