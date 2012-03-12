//
//  DealImageDelegate.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//

@class DealItem;

@protocol DealImageDelegate

@required
- (void)couldNotLoadImageError:(NSError *)error;

@optional
- (void)didLoadImage:(UIImage *)image;

@end
