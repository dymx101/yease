//
//  map.h
//  yydr
//
//  Created by 毅 李 on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "iViewController.h"

@interface map : iViewController<MKMapViewDelegate>
{
    MKMapView *mapView;
    float endLat,endLon;
    NSString *address,*title;
}

@property (nonatomic, strong) MKMapView *mapView;
-(void)setLat:(double)lat Lon:(double)lon Title:(NSString*)t Address:(NSString*)a;

@end
