//
//  BBChooseTableViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/16/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBChooseTableViewController.h"
#import "BBPlanTableViewCell.h"
#import "BBPlan.h"
#import "BBPlanStore.h"
#import "PDTSimpleCalendarViewController.h"
#import <EventKit/EventKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BBChooseTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) UIAlertView *iCalSuccess;

@end


@implementation BBChooseTableViewController


- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super init];
    self.tableView.rowHeight = 60;
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Choose Plan";
        NSString *dateString = [NSDateFormatter localizedStringFromDate:self.dateChosen dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        navItem.title = dateString;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeDateToSelf:) name:@"selectedDate" object:nil];
    
    UINib *nib = [UINib nibWithNibName:@"BBPlanTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BBPlanTableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BBPlanStore sharedStore] allPlans] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BBPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBPlanTableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *trainingPlans = [[BBPlanStore sharedStore] allPlans];
    BBPlan *plan = trainingPlans[indexPath.row];
   
    
    cell.planNameLabel.text = plan.planName;
    
    self.plan.planName = plan.planName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //find out the name of the plan from the selected row
    
    NSArray *trainingPlans = [[BBPlanStore sharedStore] allPlans];
    
    BBPlan *selectedPlan = trainingPlans[indexPath.row];
    
    self.nameFromSelectedRow = selectedPlan.planName;
    
    //use AlertView to add to iCal or post to Facebook
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add Plan"
                                                      message:@"Add to iCal or Facebook"
                                                     delegate:self
                                            cancelButtonTitle:@"Add to iCal"
                                            otherButtonTitles:@"Share on Facebook", nil];
    
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSLog(@"button index, %ld", (long)buttonIndex);
    
    if (buttonIndex == 0) {
        NSLog(@"Add to iCal");
        NSLog(@"You selected %@, which happens on %@", self.nameFromSelectedRow, self.dateChosen);
        
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = self.nameFromSelectedRow;
            event.startDate = self.dateChosen; //today
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            
            //add notification on the day the plan was added to
            UILocalNotification *futureNotification = [[UILocalNotification alloc] init];
            futureNotification.alertBody = @"Training Today!";
            futureNotification.fireDate = self.dateChosen;
            
        }];
    } else if (buttonIndex == 1) {
        NSLog(@"share to facebook");
        //ADD TO FB
        // Check if the Facebook app is installed and we can present the share dialog
        FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
        params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentShareDialogWithParams:params]) {
            // Present the share dialog
            [FBDialogs presentShareDialogWithLink:params.link
                                          handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                              if(error) {
                                                  // An error occurred, we need to handle the error
                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                  NSLog(@"Error publishing story: %@", error.description);
                                              } else {
                                                  // Success
                                                  NSLog(@"result %@", results);
                                              }
                                          }];
        } else {
            // Present the feed dialog
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Sharing Tutorial", @"name",
                                           @"Build great social apps and get more installs.", @"caption",
                                           @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                           @"https://developers.facebook.com/docs/ios/share/", @"link",
                                           @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                           nil];
            //            @"Training",
            //            self.plan.planName,
            
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // An error occurred, we need to handle the error
                                                              // See: https://developers.facebook.com/docs/ios/errors
                                                              NSLog(@"Error publishing story: %@", error.description);
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User cancelled.
                                                                      NSLog(@"User cancelled.");
                                                                      
                                                                  } else {
                                                                      // User clicked the Share button
                                                                      NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"result %@", result);
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.iCalSuccess = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"Your Plan was successfully added to iCal"
                                                     delegate:nil
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
        [self.iCalSuccess show];
        [self performSelector:@selector(dismissAlert:) withObject:nil afterDelay:1.0f];
    }
    
    
    
}

- (void)dismissAlert:(UIAlertView *)alertView
{
    [self.iCalSuccess dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


@end
