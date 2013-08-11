//
//  place_add_map.h
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "iViewController.h"
@interface place_add_map : iViewController<MKMapViewDelegate>
{
    MKMapView *mapView;
    MKPointAnnotation *dropPin;
    UIImageView *cros;
}

@property (nonatomic, strong) MKMapView *mapView;
@end
