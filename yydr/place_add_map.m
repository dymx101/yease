//
//  place_add_map.m
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import "place_add_map.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"

@interface place_add_map ()

@end

@implementation place_add_map
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
        
        float lat=[[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] doubleValue];
        float lng=[[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] doubleValue];
        
        if(lat>0)
        {
            MKCoordinateRegion region;
            
            MKCoordinateSpan span;
            span.latitudeDelta = 0.05;
            span.longitudeDelta = 0.05;
            
            CLLocationCoordinate2D theCoordinate;
            theCoordinate.latitude=lat;
            theCoordinate.longitude=lng;
            
            
            region.span = span;
            region.center = theCoordinate;

            [self.mapView setRegion:region animated:NO];
        }
        else
        {
            self.mapView.showsUserLocation = YES;
        }
        
        
        cros=[self.view  addImageViewWithCenter:self.view
                                          image:@"member_loc.png"
                                       position:self.mapView.center];
        cros.alpha=0;
        

    }
    return self;
}


- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    self.mapView.showsUserLocation = NO;
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
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",center.latitude]
                                              forKey:@"lat"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",center.longitude]
                                              forKey:@"lng"];
    
}

-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
