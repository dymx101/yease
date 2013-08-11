//
//  UIPlaceHolderTextView.h
//  yydr
//
//  Created by liyi on 13-2-13.
//
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
