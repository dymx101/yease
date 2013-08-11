//
//  page_10.m
//  StarCoach
//
//  Created by liyi on 11-5-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "page_10.h"
#import "ba.h"

@implementation page_10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer 
{
    [self removeFromSuperview];
}


-(void) lon:(double) _lon lat:(double) _lat name:(NSString*) n address:(NSString*) a
{
    
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    map.backgroundColor = [UIColor blackColor];
    [map setMapType: MKMapTypeStandard];
    [self addSubview:map];
    [self addSubview:[self createImageView:@"3_1" type:@"png" x:134 y:52]];
    //返回按钮
    [self addSubview:[self createImageViewButton:@"closeBt2" 
                                       highlight:nil 
                                            type:@"png" 
                                        position:CGPointMake(980, 53) 
                                          offset:CGPointMake(0, 0) 
                                               t:12222 
                                          action:@selector(onDown:)]];
    
    //定位
    //map.showsUserLocation=YES;
    //map.zoomEnabled=NO;
    
    CLLocationCoordinate2D theCenter;
    
    MKCoordinateRegion theRegin;
    theCenter.latitude = _lat;//31.22;
    theCenter.longitude = _lon;//121.48;
    theRegin.center=theCenter;
    
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta = 0.5;
    theSpan.longitudeDelta = 0.5;
    
    theRegin.span = theSpan;
    [map setRegion:theRegin];
    [map regionThatFits:theRegin];
    
    map.delegate=self;
    
    
    //-------------
    ba *mycompany = [[ba alloc] initWithCoordinate:theCenter];
    mycompany.title = n;
    mycompany.subtitle = a;
    [map addAnnotation:mycompany];
    
    /*
    CLLocationCoordinate2D aaa;
    aaa.latitude=_lat;
    aaa.longitude=_lon;
    
    ba *bb = [[[ba alloc] initWithCoordinate:aaa] autorelease];
    bb.title = @"经销商2";
    bb.subtitle = @"地址";
    
    
    [map addAnnotation:bb];*/
    
    //------
    locmanager = [[CLLocationManager alloc] init]; 
    [locmanager setDelegate:self]; 
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];	
    [locmanager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    
    
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for(MKPinAnnotationView *aV in views)
    {
        CGRect endFrame = aV.frame;
        
        //down
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [aV setFrame:endFrame];
        
        [UIView commitAnimations];
/*
        aV.pinColor=MKPinAnnotationColorGreen;
        UIButton *bt=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aV.rightCalloutAccessoryView=bt;*/
    }    
}
-(void)onDown:(UIGestureRecognizer*)sender
{
    [self removeFromSuperview];
}
@end
