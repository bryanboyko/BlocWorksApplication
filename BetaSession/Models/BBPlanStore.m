//
//  BBPlanStore.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPlanStore.h"
#import "BBPlan.h"

@interface BBPlanStore ()

@property (nonatomic) NSMutableArray *privatePlans;

@end

@implementation BBPlanStore

+ (instancetype)sharedStore
{
    static BBPlanStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"use [BBPlanStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.privatePlans = [[NSMutableArray alloc] init];
        
        NSString *path = [self planArchivePath];
        _privatePlans = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //if the array hadnt been saved previously, create a new empty one
        if (!_privatePlans) {
            _privatePlans = [[NSMutableArray alloc] init];
            
            NSLog(@"plan initialized");
        }
    }
    return self;
}

- (NSArray *)allPlans
{
    return self.privatePlans;
}

- (BBPlan *)createPlan
{
    BBPlan *plan = [[BBPlan alloc] init];
    
    [self.privatePlans addObject:plan];
    NSLog(@"privatePlans array contents: %@", self.privatePlans);
    NSLog(@"plan created");
    
    return plan;
}

- (void)removePlan:(BBPlan *)plan
{
    //code for archiving images if needed
    //NSString *key = plan.planKey;
    //[[BBImageStore sharedStore] deleteImageForKey:key];
    
    [self.privatePlans removeObjectIdenticalTo:plan];
}

- (NSString *)planArchivePath
{
    NSArray *documentDictionaries = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //get the one document directory from the list
    NSString *documentDirectory = [documentDictionaries firstObject];
    
    NSLog(@"exercise archive path is: %@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:@"plans.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self planArchivePath];
    
    //returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privatePlans toFile:path];
}


@end