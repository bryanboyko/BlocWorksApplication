//
//  BBChooseExerciseTableViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPlan;

@interface BBChooseExerciseTableViewController : UITableViewController

@property (nonatomic, strong) BBPlan *plan;
@property (nonatomic, copy) void (^dismissBlock)(void);


@end
