//
//  BBMapAnnotation.m
//  GoogleMapsAPIExample
//
//  Created by Bryan Boyko on 8/7/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBMapAnnotation.h"

@implementation BBMapAnnotation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        self.name = [name copy];
        self.address = [address copy];
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    if ([self.name isKindOfClass:[NSNull class]]) {
        return @"unknown charge";
    } else {
        return self.name;
    }
}

- (NSString *)subtitle
{
    return self.address;
}
@end
