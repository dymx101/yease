//
//  ba.h
//  map
//
//  Created by liyi on 11-5-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface position : NSObject<MKAnnotation> {
    
    CLLocationCoordinate2D theCoordinate;
    NSString *title;
    NSString *address;
}

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *address;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
