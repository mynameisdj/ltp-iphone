//
//  UIStrikeLabel.m
//  StrikedLabelSample
//
//  Created by Min-gu, Kim on 10. 9. 16..
//  Copyright 2010 더블가이. All rights reserved.
//

#import "UIStrikeLabel.h"
#define strikeHeight 1.0


@interface UIStrikeLabel()

- (CGRect) getStrikeRect:(CGFloat)strikeWidth;

@end

@implementation UIStrikeLabel
//@synthesize strike;

- (void) drawTextInRect:(CGRect)rect {
	[super drawTextInRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
//	if([self strike])
	{
		CGSize textSize = [[self text] sizeWithFont:[self font]];	
		CGFloat strikeWidth = textSize.width;	
		CGContextFillRect(context, [self getStrikeRect:strikeWidth]);
	}
}

- (CGRect)getStrikeRect:(CGFloat)strikeWidth {
	
	CGRect strikeRect;
	CGFloat x;
	CGFloat y = (self.frame.size.height - strikeHeight) / 2.0;
	
	switch ([self textAlignment]) {
		default:
		case UITextAlignmentLeft:
			x = 0;
			break;
		case UITextAlignmentCenter:
			x = (self.frame.size.width - strikeWidth) / 2.0;
			break;
		case UITextAlignmentRight:
			x = self.frame.size.width - strikeWidth;
			break;
	}
	
	strikeRect = CGRectMake(x, y, strikeWidth, strikeHeight);
	
	return strikeRect;
}

@end
