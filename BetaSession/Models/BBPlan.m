//
//  BBPlan.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPlan.h"
#import "BBPlanExerciseIndexPath.h"

@interface BBPlan ()

@end

@implementation BBPlan

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _planName = [aDecoder decodeObjectForKey:@"planName"];
        _planKey = [aDecoder decodeObjectForKey:@"planKey"];
        _planExerciseArray = [aDecoder decodeObjectForKey:@"planExerciseArray"];
    }
    return self;
}

- (instancetype)initWithPlanName:(NSString *)planName planExerciseArray:(NSMutableArray *)planExerciseArray
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _planName = planName;
        _planExerciseArray = planExerciseArray;
        _planExerciseArray = [[NSMutableArray alloc] init];
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _planKey = key;
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (instancetype)init
{
    return [self initWithPlanName:@"plan" planExerciseArray:nil];
}


- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}


- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"planName: %@, planExerciseArray: %@",
     self.planName, self.planExerciseArray];
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"encoded the plans");
    [aCoder encodeObject:self.planName forKey:@"planName"];
    [aCoder encodeObject:self.planKey forKey:@"planKey"];
    [aCoder encodeObject:self.planExerciseArray forKey:@"planExerciseArray"];
}


@end
