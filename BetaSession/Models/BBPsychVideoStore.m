//
//  BBPsychVideoStore.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/17/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPsychVideoStore.h"
#import "BBPsychVideo.h"

@interface BBPsychVideoStore ()

@property (nonatomic) NSMutableArray *privatePsychVideos;

@end

@implementation BBPsychVideoStore

+ (instancetype)sharedStore
{
    static BBPsychVideoStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"Use + [BBPsychVideoStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self pvArchivePath];
        
        _privatePsychVideos = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_privatePsychVideos) {
            _privatePsychVideos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)removePsychVideo:(BBPsychVideo *)psychVideo
{
    [self.privatePsychVideos removeObjectIdenticalTo:psychVideo];
}

- (NSArray *)allPsychVideos
{
    return self.privatePsychVideos;
}

- (BBPsychVideo *)createPsychVideo
{
    BBPsychVideo *psychVideo = [[BBPsychVideo alloc] init];
    
    [self.privatePsychVideos addObject:psychVideo];
    
    NSLog(@"vids in store: %@", self.allPsychVideos);
    
    return psychVideo;
}

- (NSString *)pvArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"psychVideos.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self pvArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privatePsychVideos toFile:path];
}

@end