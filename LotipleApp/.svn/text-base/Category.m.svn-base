//
//  Category.m
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import "Category.h"

@implementation Category

Category* _category;


+ (id)instance
{
	if (!_category)
	{
		_category = [[Category alloc] init];
	}
	
	return _category;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	
	return self;
}

- (UIImage*)getImage:(NSString*)fileName
{
	UIImage* image = [imageCache objectForKey:fileName];
	if (!image)
	{
		image = [UIImage imageNamed:fileName];
		[imageCache setObject:image forKey:fileName];
	}
	
	return image;
}

+ (UIImage*)mapIcon:(CategoryType)categoryType
{	
	NSString* fileName = nil;
	
	switch (categoryType)
	{
		case CategoryTypeGurumet:
			fileName = @"food.png";
			break;
		case CategoryTypeCafeBar:
			fileName = @"cafe.png";
			break;
		case CategoryTypeBeauty:
			fileName = @"beauty32px.png";
			break;
		case CategoryTypeLifeHealth:
			fileName = @"life32px.png";
			break;
		case CategoryTypeTravelLeisure:
			fileName = @"trip32px.png";
			break;
		case CategoryTypeConcertCulture:
			fileName = @"show32px.png";
            break;
        default:
            fileName = @"life32px.png";
            break;
	}
	
	return [[Category instance] getImage:fileName];
}

@end
