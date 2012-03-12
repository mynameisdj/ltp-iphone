//
//  UITimeboxView.m
//  LotipleApp
//
//  Created by Sol_Air on 11. 5. 4..
//  Copyright 2011 Home. All rights reserved.
//

#import "UITimeboxView.h"


@implementation UITimeboxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect rrect = [self bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();    
    CGContextSetLineWidth(context, 2.0);
    CGFloat magenta[4] = {0.925f, 0.0f, 0.55f, 1.0f};
    CGContextSetStrokeColor(context, magenta);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, rrect.size.height);    
    CGContextAddLineToPoint(context, rrect.size.width, rrect.size.height);
    CGContextAddLineToPoint(context, rrect.size.width, 0);    
    CGContextStrokePath(context);

    
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
