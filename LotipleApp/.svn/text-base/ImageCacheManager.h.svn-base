//
//  ImageCacheManager.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 7..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageCacheManager : NSObject {
    NSLock* cacheLock;
    NSMutableDictionary* imageCache;
}
+ (id)instance;
- (NSData*) getImageFromCache:(NSString*)url;
- (void)saveImageCacheImg:(NSData*)imgData andUrl:(NSString*)url;

@end
