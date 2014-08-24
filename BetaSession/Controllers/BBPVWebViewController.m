//
//  BBPVWebViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/17/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBPVWebViewController.h"
#import "BBPsychVideo.h"
#import "BBTrainingVideoViewController.h"
#import "BBPsychVideoStore.h"

@interface BBPVWebViewController ()

@end

@implementation BBPVWebViewController
@synthesize webView;

- (instancetype)init{
    self = [super init];
    if (self) {
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];[[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        self.navigationController.title = self.psychVideo.psychVideoName;
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"URL loaded?: %@", self.URL);
    NSURL *url = [NSURL URLWithString:self.URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    [super viewDidLoad];
    
    //custom back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"Back"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

//method for custom nav bar
- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
