//
//  BBAppDelegate.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBAppDelegate.h"
#import "PDTSimpleCalendarViewController.h"
#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewHeader.h"
#import "BBLoadViewController.h"
#import "BBExerciseStore.h"
#import "BBPlanStore.h"
#import "BBPsychVideoStore.h"

@interface BBAppDelegate () <PDTSimpleCalendarViewDelegate>

@property (nonatomic, strong) NSArray *customDates;

@end

@implementation BBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor blackColor];
    
    //1. add the image to the front of the view...
    UIImageView *splashImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [splashImage setImage: [UIImage imageNamed:@"BetaSessionsLoadView"]];
    [self.window addSubview:splashImage];
    [self.window bringSubviewToFront:splashImage];
    
    //2. set an anchor point on the image view so it opens from the left
    splashImage.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //reset the image view frame
    splashImage.frame = self.window.bounds;
    
    //3. animate the open
    [UIView animateWithDuration:0.2
                          delay:0.6
                        options:(UIViewAnimationCurveEaseInOut)
                     animations:^{
                         
                         splashImage.layer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
                     } completion:^(BOOL finished){
                         
                         //remove that imageview from the view
                         [splashImage removeFromSuperview];
                     }];
    
    [self performSelector:@selector(setNavigationController) withObject:nil afterDelay:1.2];
    
    //change status bar color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setNavigationController
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    _customDates = @[[dateFormatter dateFromString:@"01/05/2014"], [dateFormatter dateFromString:@"01/06/2014"], [dateFormatter dateFromString:@"01/07/2014"]];
    
    PDTSimpleCalendarViewController *calendarViewController = [[PDTSimpleCalendarViewController alloc] init];
    //This is the default behavior, will display a full year starting the first of the current month
    [calendarViewController setDelegate:self];
    
    
    //Create Navigation Controller
    UINavigationController *defaultNavController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    self.window.rootViewController = defaultNavController;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[BBExerciseStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"saved all of the BBExercises");
    } else {
        NSLog(@"could not save BBExercises");
    }
    BOOL alsoSuccess = [[BBPlanStore sharedStore] saveChanges];
    if (alsoSuccess) {
        NSLog(@"saved all of the BBPlans");
    } else {
        NSLog(@"could not save BBPlans");
    }
    BOOL success3 = [[BBPsychVideoStore sharedStore] saveChanges];
    if (success3) {
        NSLog(@"saved all of the BBPsychVideos");
    } else {
        NSLog(@"could not save BBPsychVideos");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
