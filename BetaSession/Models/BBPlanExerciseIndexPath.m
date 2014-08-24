//
//  BBPlanExerciseIndexPath.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPlanExerciseIndexPath.h"

@implementation BBPlanExerciseIndexPath

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.exerciseIndexPath = [aDecoder decodeObjectForKey:@"exerciseIndexPath"];
    }
    return self;
}

- (instancetype)initWithExerciseIndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    
    if (self) {
        _exerciseIndexPath = indexPath;
        NSLog(@"planExerciseIndexPath initialized");
    }
    
    
    return self;
}

- (instancetype)init{
    return [self initWithExerciseIndexPath:nil];
}



- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"exerciseIndexPath: %@", self.exerciseIndexPath];
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"encoded the index path");
    [aCoder encodeObject:self.exerciseIndexPath forKey:@"exerciseIndexPath"];
}

@end
