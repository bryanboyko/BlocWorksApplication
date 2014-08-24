//
//  BBPlanDetailViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPlan;

@interface BBPlanDetailViewController : UIViewController

@property (nonatomic, strong) BBPlan *plan;

- (instancetype)initForNewPlan:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
