//
//  BBWebViewController1.m
//  Training
//
//  Created by Bryan Boyko on 6/9/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBWebViewController1.h"
#import "BBPsychVideo.h"
#import "BBPVDetailViewController.h"
#import "BBPsychVideoStore.h"


@interface BBWebViewController1 ()


@end

@implementation BBWebViewController1
@synthesize webView;

- (void)viewDidLoad
{
    NSURL *url = [NSURL URLWithString:@"http://www.youtube.com"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"Back"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *chooseVideo = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(selectURL)];
    self.navigationItem.rightBarButtonItem = chooseVideo;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)isLoading
{
    if (self.webView.isLoading) {
        return;
    } else {
        [self performSelector:@selector(selectURL) withObject:nil];
    }
}



- (void)selectURL
{
    NSString *currentURL = webView.request.URL.absoluteString;
    NSLog(@"%@", currentURL);
    self.videoURL = currentURL;
    
    
    BBPsychVideo *pv = [[BBPsychVideoStore sharedStore] createPsychVideo];
    BBPVDetailViewController *dvc = [[BBPVDetailViewController alloc] initForNewPsychVideo:YES];
    dvc.psychVideo = pv;
    //add current webview url to psychvideo instance
    dvc.psychVideo.psychVideoURL = self.videoURL;
    dvc.dismissBlock = ^{[self.navigationController popViewControllerAnimated:YES];};
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dvc];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}
@end
