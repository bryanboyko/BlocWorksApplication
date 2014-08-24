//
//  BBDetailViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBExercise;

@interface BBDetailViewController : UIViewController

@property (nonatomic, strong) BBExercise *exercise;

- (instancetype)initForNewExercise:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
