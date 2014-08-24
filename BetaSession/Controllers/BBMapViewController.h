//
//  BBMapViewController.h
//  BetaSession
//
//  Created by Bryan Boyko on 8/13/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BBMapAnnotation.h"

#define kGOOGLE_API_KEY @"AIzaSyA8B-Z-Tc27boMmbvpx5mnc-zV282KdGNU"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface BBMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

- (IBAction)findClimbingNearby:(id)sender;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentCenter;
@property (nonatomic) int currentDistance;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) BOOL firstLaunch;

@property (nonatomic) IBOutlet UIView *mapBoxViewArea;




#pragma DRAWER

@property (nonatomic, retain) NSArray *menuItems;
@property (strong, nonatomic) IBOutlet UILabel *mainTitle;

@property (readonly, nonatomic) UISwipeGestureRecognizer *recognizer_open, *recognizer_close;
@property (readonly, nonatomic) int menuDrawerX, menuDrawerWidth;
@property (nonatomic) UIView *menuDrawer;


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender;
- (void)drawerAnimation;

@end
