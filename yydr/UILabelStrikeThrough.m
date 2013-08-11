//
//  UILabelStrikeThrough.m
//  yydr
//
//  Created by liyi on 13-4-2.
//
//

#import "UILabelStrikeThrough.h"

@implementation UILabelStrikeThrough

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat black[4] = {100.f/255.f, 100.f/255.f, 100.f/255.f, 1.0f};
    CGContextSetStrokeColor(c, black);
    CGContextSetLineWidth(c, 1);
    CGContextBeginPath(c);
    CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
    CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp );
    CGContextAddLineToPoint(c, self.bounds.origin.x + self.bounds.size.width, halfWayUp);
    CGContextStrokePath(c);
    
    [super drawRect:rect];
}


@end
