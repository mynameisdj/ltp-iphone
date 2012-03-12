//
//  Like.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 27..
//  Copyright 2011 Home. All rights reserved.
//

#import "Like.h"

#import "ServerConnection.h"

@implementation Like

@synthesize name, imgPath;
@synthesize category;

+ (id)likeWithJSON:(NSDictionary*)json imgPath:(NSString*)imgPath
{
	id newLike = [[[Like alloc] initWithJSON:json imgPath:imgPath] autorelease];
	return newLike;
}

- (id)initWithJSON:(NSDictionary*)json imgPath:(NSString*)aImgPath
{
	self.name = [json objectForKey:@"name"];
	self.imgPath = aImgPath;
	
	category = [[json objectForKey:@"category"] intValue];

	
	return self;
}

- (UIImage*)getImage
{
	return [[ServerConnection instance] getStoreImg:imgPath];
}

@end
