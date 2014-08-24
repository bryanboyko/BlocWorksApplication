//
//  BBPVWebViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/17/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPsychVideo;

@interface BBPVWebViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic) NSString *URL;
@property (nonatomic) BBPsychVideo *psychVideo;

@end
