//
//  UITextField+Custom.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 16..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LTPUITextField : UITextField
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
