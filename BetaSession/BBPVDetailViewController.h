//
//  BBPVDetailViewController.h
//  Training
//
//  Created by Bryan Boyko on 5/30/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPsychVideo;

@interface BBPVDetailViewController : UIViewController

@property (nonatomic, strong) BBPsychVideo *psychVideo;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewPsychVideo:(BOOL)isNew;

@end
