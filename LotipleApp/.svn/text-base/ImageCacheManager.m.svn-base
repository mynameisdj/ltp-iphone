//
//  ImageCacheManager.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 7..
//  Copyright 2011 Home. All rights reserved.
//

#import "ImageCacheManager.h"


@implementation ImageCacheManager

ImageCacheManager* _imageCacheManager;

+ (id)instance
{   
    @synchronized (self) {
        if (!_imageCacheManager)
        {
            _imageCacheManager = [[ImageCacheManager alloc] init];		
        }
        
    }	
	return _imageCacheManager;
}

- (id)init
{
	self = [super init];
    cacheLock = [[NSLock alloc] init];
    imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
    return self;
}

- (void)dealloc
{
    [cacheLock release];
	[imageCache release];
    [super dealloc];
}

- (NSData*) getImageFromCache:(NSString*)url
{
    [cacheLock lock];
    NSData* image = [imageCache objectForKey:url];
    [cacheLock unlock];
    return image;
}

- (void)saveImageCacheImg:(NSData*)imgData andUrl:(NSString*)url;
{
    if ( [self getImageFromCache:url] == nil )
        [imageCache setObject:imgData forKey:url];
}

@end
