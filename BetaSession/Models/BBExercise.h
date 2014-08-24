//
//  BBExercise.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBExercise : NSObject <NSCoding>

@property (nonatomic, copy) NSString *exerciseName;
@property (nonatomic, copy) NSString *exerciseStyle;
@property (nonatomic, copy) NSURL *videoURL;

@property (nonatomic, copy) NSString *exerciseKey;
@property (nonatomic, strong) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;

// Designated initializer for BNRItem
- (instancetype)initWithExerciseName:(NSString *)exerciseName
                       exerciseStyle:(NSString *)exerciseStyle
                            videoURL:(NSURL *)videoURL;

- (instancetype)initWithExerciseName:(NSString *)exerciseName;

@end
