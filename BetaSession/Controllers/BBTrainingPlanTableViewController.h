//
//  BBTrainingPlanTableViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBPlan.h"

@interface BBTrainingPlanTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UISwipeGestureRecognizer *cellStartEditing, *cellStopEditing;


@property (nonatomic) BBPlan *plan;


@end
