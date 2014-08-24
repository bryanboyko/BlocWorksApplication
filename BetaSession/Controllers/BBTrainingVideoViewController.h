//
//  BBTrainingVideoViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBWebViewController1.h"

@class BBPsychVideo;
@class BBPVWebViewController;

@interface BBTrainingVideoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BBPVWebViewController *webViewControllerPV;
@property (nonatomic) BBWebViewController1 *webViewController1;
@property (nonatomic) BBPsychVideo *psychVideo;

#pragma DRAWER

@property (nonatomic, retain) NSArray *menuItems;
@property (strong, nonatomic) IBOutlet UILabel *mainTitle;

@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_open, *recognizer_close;
@property (readonly, nonatomic) int menuDrawerX, menuDrawerWidth;
@property (nonatomic) UIView *menuDrawer;


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender;
- (void)drawerAnimation;

@end
