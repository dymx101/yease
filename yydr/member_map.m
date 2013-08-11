//
//  member_map.m
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import "member_map.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"

@interface member_map ()

@end

@implementation member_map
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)];
        self.mapView.delegate=self;
        
        [self.view addSubview:mapView];
  
        dropPin = [[MKPointAnnotation alloc] init];
        [self.mapView addAnnotation:dropPin];
        
        cros=[self.view  addImageViewWithCenter:self.view
                                     image:@"member_loc.png"
                                  position:self.mapView.center];
        cros.alpha=0;
        
        self.mapView.showsUserLocation = YES;
        
    }
    return self;
}




- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
    cros.alpha=1;

}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    
    CLLocationCoordinate2D center = [self.mapView centerCoordinate];
    dropPin.coordinate=center;
    cros.alpha=0;
}


//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    for(MKPinAnnotationView *aV in views)
//    {
//        CGPoint endCenter=aV.center;
//        
//        aV.center=CGPointMake(aV.center.x, aV.center.y-300);
//    
//        [UIView animateWithDuration:1
//                         animations:^{
//                             aV.center=endCenter;
//                         }];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onRDown:)
                                                             target:self];


}

-(void)onRDown:(UIButton*)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
