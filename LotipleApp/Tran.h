//
//  Tran.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 27..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHelper.h"
#import "DealImageDelegate.h"

@class DealItem;
@class Store;

@interface Tran : NSObject <ServerOperationDelegate>
{
	NSString* deal_title;
	NSString* store_name;
	NSString* coupon_name;
	NSDate* end_time;
    NSDate* purchase_time;
    int status;
    int total_price;
    NSString* store_address;
    NSString* store_address2;
    NSString* phone;
    int x;
    int y;
    int count;
	UIImage* thumbnail;
    NSString* imgPath;
	DealItem* deal;
    ServerHelper *serverHelper;
    NSObject<DealImageDelegate> *delegate;
}
@property (nonatomic, retain) UIImage* thumbnail;
@property (nonatomic, retain) NSString* deal_title;
@property (nonatomic, retain) NSString* store_name, *store_address, *store_address2, *phone, *imgPath;
@property (nonatomic, retain) NSString* coupon_name;
@property (nonatomic, retain) NSDate* end_time, *purchase_time;
@property (nonatomic, assign) int status, x, y, count, total_price;
@property (nonatomic, retain) DealItem* deal;
@property (nonatomic, assign) NSObject<DealImageDelegate> *delegate;


- (id)initWithJSON:(NSDictionary*)json;
- (NSDate*) getNSDateFromJSON:(NSDictionary*)json andKey:(NSString*)key_val;

- (UIImage*)getImage;
- (NSString*)getRemainTime;
- (NSString*)getStatusString;
- (BOOL)hasLoadedThumbnail;

@end
