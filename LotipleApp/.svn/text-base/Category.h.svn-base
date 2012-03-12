//
//  Category.h
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	CategoryTypeInvalid = 0,
	CategoryTypeGurumet = 1,
	CategoryTypeCafeBar = 2,
	CategoryTypeBeauty = 3,
	CategoryTypeLifeHealth = 4,
	CategoryTypeTravelLeisure = 5,
	CategoryTypeConcertCulture = 6,
} CategoryType;


@interface Category : NSObject
{
	NSMutableDictionary* imageCache;
}

+ (id)instance;

+ (UIImage*)mapIcon:(CategoryType)categoryType;

@end
