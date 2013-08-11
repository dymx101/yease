//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation Harpy

#pragma mark - Public Methods
+ (void)checkVersion:(BOOL)show
{
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                //NSLog(@"%@",versionsInAppStore);
                
                if ( ![versionsInAppStore count] ) {
                    // No versions of app in AppStore
                    
                } else {

                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];

                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
            
                        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
	                
                    }
                    else {
		            
                        if(show)
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"夜色"
                                                                                message:@"当前已经是最新版本了"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确认"
                                                                      otherButtonTitles:nil, nil];
                            
                            [alertView show];
                        }
                    }

                }
              
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    //NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( harpyForceUpdate ) {
        //强制升级
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"夜色"
                                                            message:[NSString stringWithFormat:@"发现新版本v%@，是否立即更新？", currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app
        //允许下次升级
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"夜色"
                                                            message:[NSString stringWithFormat:@"发现新版本v%@，是否立即更新？", currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ( harpyForceUpdate ) {

        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
    } else {

        switch ( buttonIndex ) {
                
            case 0:{
                // Do nothing
                
            } break;
                
            case 1:{ // Update
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } break;
                
            default:
                break;
        }
        
    }

    
}

@end
