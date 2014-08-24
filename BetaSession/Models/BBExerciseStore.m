//
//  BBExerciseStore.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBExerciseStore.h"
#import "BBExercise.h"
#import "BBImageStore.h"

@interface BBExerciseStore ()

@property (nonatomic) NSMutableArray *privateExercises;

@end


@implementation BBExerciseStore

+ (instancetype)sharedStore
{
    static BBExerciseStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"use [BBExerciseStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.privateExercises = [[NSMutableArray alloc] init];

        
        NSString *path = [self exerciseArchivePath];
        _privateExercises = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //if the array hadnt been saved previously, create a new empty one
        if (!_privateExercises) {
            _privateExercises = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allExercises
{
    return self.privateExercises;
}

- (BBExercise *)createExercise
{
    BBExercise *exercise = [[BBExercise alloc] init];
    
    [self.privateExercises addObject:exercise];
    
    return exercise;
}

- (void)removeExercise:(BBExercise *)exercise
{
    NSString *key = exercise.exerciseKey;
    
    [[BBImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateExercises removeObjectIdenticalTo:exercise];
}

- (NSString *)exerciseArchivePath
{
    NSArray *documentDictionaries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //get the one document directory from the list
    NSString *documentDirectory = [documentDictionaries firstObject];
    
    NSLog(@"exercise archive path is: %@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:@"exercises.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self exerciseArchivePath];
    
    //returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateExercises toFile:path];
}


@end