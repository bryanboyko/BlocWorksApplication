//
//  BBPlan.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBExercise.h"

@interface BBPlan : NSObject <NSCoding>

@property (nonatomic, copy) NSString *planName;
@property (nonatomic, copy) NSString *planKey;
@property (nonatomic) NSMutableArray *planExerciseArray;

// Designated initializer for BNRItem
- (instancetype)initWithPlanName:(NSString *)planName
               planExerciseArray:(NSMutableArray *)planExerciseArray;

- (void)removeExerciseFromPlan:(BBExercise *)exercise;

@end
