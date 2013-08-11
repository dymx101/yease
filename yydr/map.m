//
//  map.m
//  yydr
//
//  Created by 毅 李 on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "map.h"
#import "position.h"
#import "UIView+iButtonManager.h"


@interface map ()

@end

@implementation map

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)];
        self.mapView.delegate=self;
       
        [self.view addSubview:mapView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
    self.navigationItem.rightBarButtonItem=[self.view add_nav_button:@selector(onRDown:)
                                                              target:self];
}


-(void)onBack:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


-(void)onRDown:(UIButton*)sender
{
    
    float  glat=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Glat"] floatValue];
    float  glng=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Glng"] floatValue];
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) { // ios6以下，调用google map
        
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d",glat,glng,endLat,endLon];
        NSURL *aURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:aURL];
    }
    else
    { // 直接调用ios自己带的apple map
        CLLocationCoordinate2D to;
        to.latitude = endLat;
        to.longitude = endLon;
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
        
        toLocation.name = address;

        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    
}




-(void)setLat:(double)lat Lon:(double)lon Title:(NSString*)t Address:(NSString*)a
{
    NSLog(@"setLat lat=%f lon=%f",lat,lon);

    endLat=lat;
    endLon=lon;
    
    address=a;
    
    
    position *item = [[position alloc] init];
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude=lat;
    theCoordinate.longitude=lon;
    [item setCoordinate:theCoordinate];
    
    item.title=t;
    item.address=a;
    
    [self.mapView removeAnnotations:self.mapView.annotations];// remove any annotations that exist
    [self.mapView addAnnotation:item];

    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = lat;
    newRegion.center.longitude = lon;
    
    //范围
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;

    [self.mapView setRegion:newRegion
                   animated:YES];

    //标记自动显示
    [self.mapView selectAnnotation:item
                          animated:YES];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[position class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *placeAnnotationIdentifier = @"placeAnnotationIdentifier";
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:placeAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                 reuseIdentifier:placeAnnotationIdentifier];
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }

    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.mapView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
