//
//  BBExerciseStore.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBExercise;

@interface BBExerciseStore : NSObject

@property (nonatomic, readonly) NSArray *allExercises;
@property (nonatomic, readonly) NSArray *allIndividualPlanExercises;

//exercise chosen in BBChooseExerciseTableViewController
@property (nonatomic) BBExercise *receivedExercise;

+ (instancetype)sharedStore;
- (BBExercise *)createExercise;

- (void)removeExercise:(BBExercise *)exercise;

- (BOOL)saveChanges;

@end
