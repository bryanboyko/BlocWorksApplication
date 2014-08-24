//
//  BBWebViewController1.h
//  Training
//
//  Created by Bryan Boyko on 6/9/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPsychVideo;

@interface BBWebViewController1 : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic) NSString *videoURL;
@property (nonatomic, strong)
BBPsychVideo *psychVideo;

@end
