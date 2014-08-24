//
//  BBPlanExerciseIndexPath.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPlanExerciseIndexPath : NSObject <NSCoding>

@property (nonatomic) NSIndexPath *exerciseIndexPath;

- (instancetype)initWithExerciseIndexPath:(NSIndexPath *)indexPath;

@end
