//
//  BBPsychVideo.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/17/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPsychVideo : NSObject <NSCoding>

- (instancetype)initWithPsychVideoName:(NSString *)psychVideoName
                         psychVideoURL:(NSString *)psychVideoURL;

@property (nonatomic) NSString *psychVideoName;
@property (nonatomic) NSString *psychVideoURL;


@end
