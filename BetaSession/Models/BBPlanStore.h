//
//  BBPlanStore.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBPlan;

@interface BBPlanStore : NSObject

@property (nonatomic, readonly) NSArray *allPlans;

+ (instancetype)sharedStore;
- (BBPlan *)createPlan;

- (void)removePlan:(BBPlan *)plan;

- (BOOL)saveChanges;

@end