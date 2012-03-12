//
//  DealItem.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DealImageDelegate.h"
#import "ServerHelper.h"


@interface DealItem : NSObject <ServerOperationDelegate> {
    int			_id;
	int			original_id;
	int			area_code;

	NSString*	title;
	NSString*	subtitle;
	NSString*	description;
    NSString*   area_name;
	
	int			price;
	int			reduced_price;
	int			discount_rate;
	
	int			current_ordered_count;
	
	int			count_limit;
	int			max_count;
	int			min_count;
	
	int			store_id;
	float		store_commission;
	NSString*	store_name;
	
	NSDate*		creation_time;
	NSDate*		start_time;
	NSDate*		end_time;
	
	int			category;
	int			status;
	
	float		lng;
	float		lat;
	
	NSString*	imgPath;
	int			like;
    float     distance;
    BOOL        islike;
    UIImage* thumbnail;
    ServerHelper *serverHelper;
    NSObject<DealImageDelegate> *delegate;
}

@property (nonatomic, assign) float lng, lat, distance;
@property (nonatomic, retain) NSString* title, *store_name, *subtitle, *description, *imgPath, *area_name;
@property (nonatomic, assign) int discount_rate, price, reduced_price, area_code, store_id,_id, like, current_ordered_count, max_count, count_limit, category;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, assign) NSObject<DealImageDelegate> *delegate;

- (id)initWithJSON:(NSDictionary*)json;
- (BOOL)isDealStarted;
- (NSString*)getTimePeriod;
- (NSString*)getRemainTime;
- (BOOL)hasLoadedThumbnail;
// Image legacy Function
- (UIImage*)getSqImage;
- (NSArray*)getDetailImages;

@end
