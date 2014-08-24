//
//  BBPsychVideo.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/17/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPsychVideo.h"

@implementation BBPsychVideo

- (instancetype)initWithPsychVideoName:(NSString *)psychVideoName psychVideoURL:(NSString *)psychVideoURL
{
    self = [super init];
    
    if (self) {
        _psychVideoName = psychVideoName;
        _psychVideoURL = psychVideoURL;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _psychVideoName = [aDecoder decodeObjectForKey:@"psychVideoName"];
        _psychVideoURL = [aDecoder decodeObjectForKey:@"psychVideoURL"];
    }
    return self;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@: %@", self.psychVideoName, self.psychVideoURL];
    
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.psychVideoName forKey:@"psychVideoName"];
    [aCoder encodeObject:self.psychVideoURL forKey:@"psychVideoURL"];
}

@end