//
//  iViewController.m
//  yydr
//
//  Created by Li yi on 13-6-15.
//
//

#import "iViewController.h"

@interface iViewController ()

@end

@implementation iViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _AppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_AppDelegate.notifierView hide];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
