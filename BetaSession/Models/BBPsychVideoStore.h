//
//  BBPsychVideoStore.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/17/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBPsychVideo;

@interface BBPsychVideoStore : NSObject

@property (nonatomic, readonly) NSArray *allPsychVideos;


+ (instancetype) sharedStore;
- (BBPsychVideo *)createPsychVideo;

- (void)removePsychVideo:(BBPsychVideo *)psychVideo;

- (BOOL)saveChanges;


@end