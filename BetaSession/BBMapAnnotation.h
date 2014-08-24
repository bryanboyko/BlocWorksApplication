//
//  BBMapAnnotation.h
//  GoogleMapsAPIExample
//
//  Created by Bryan Boyko on 8/7/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BBMapAnnotation : NSObject

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
