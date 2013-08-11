//
//  ba.m
//  map
//
//  Created by liyi on 11-5-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "position.h"

@implementation position
@synthesize title;
@synthesize address;

- (CLLocationCoordinate2D)coordinate
{
    return theCoordinate;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate 
{
    theCoordinate=newCoordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return title;
}

// optional
- (NSString *)subtitle
{
    return address;
}

@end
