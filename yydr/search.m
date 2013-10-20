//
//  search.m
//  yydr
//
//  Created by Li yi on 13-10-10.
//
//

#import "search.h"

@implementation search

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
       
        
        
        
        
     
       

    
    }
    return self;
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)sb
{
    NSLog(@"aaaaa");
    
    [sb setShowsCancelButton:YES animated:YES];
    
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)sb
{
    [sb endEditing:YES];
    
    [sb setShowsCancelButton:NO animated:YES];
    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)sb
{
    
}

@end
