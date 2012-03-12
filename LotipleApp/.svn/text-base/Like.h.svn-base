//
//  Like.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 27..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Like : NSObject
{
    NSString* name;
	NSString* imgPath;

	int category;
}

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* imgPath;

@property (nonatomic) int category;

+ (id)likeWithJSON:(NSDictionary*)json imgPath:(NSString*)imgPath;

- (id)initWithJSON:(NSDictionary*)json imgPath:(NSString*)imgPath;

- (UIImage*)getImage;



@end
