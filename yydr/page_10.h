//
//  page_10.h
//  StarCoach
//
//  Created by liyi on 11-5-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "page.h"


@interface page_10 : page<MKMapViewDelegate,CLLocationManagerDelegate> {
    MKMapView			*map;
	CLLocationManager   *locmanager; 
	float lat,lon;
}
-(void) lon:(double) _lon lat:(double) _lat name:(NSString*) n address:(NSString*) a;
@end
