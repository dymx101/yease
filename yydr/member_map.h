//
//  member_map.h
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface member_map : UIViewController<MKMapViewDelegate>
{
    MKMapView *mapView;
    MKPointAnnotation *dropPin;
    UIImageView *cros;
}

@property (nonatomic, strong) MKMapView *mapView;

@end
