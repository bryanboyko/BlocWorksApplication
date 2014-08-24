//
//  BBExerciseTableViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBExerciseTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

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
