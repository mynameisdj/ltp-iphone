//
//  Tran.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 27..
//  Copyright 2011 Home. All rights reserved.
//

#import "Tran.h"

#import "DealItem.h"
#import "Store.h"
#import "ServerHelper.h"
#import "ServerUrls.h"
#import "ServerConnection.h"
#import "LTPConstant.h"

@implementation Tran

@synthesize deal_title, store_name, coupon_name, end_time, status, store_address, x, y, deal, store_address2, purchase_time, phone, count, imgPath, thumbnail, delegate, total_price;


- (NSDate*) getNSDateFromJSON:(NSDictionary*)json andKey:(NSString*)key_val
{
    NSTimeInterval timestamp = [[json objectForKey:key_val] doubleValue] / 1000;
	return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

- (id)initWithJSON:(NSDictionary*)json
{

    // TODO : should be checked, deal 을 전달하는 방식이 두가지이다.
    DealItem *_deal =[[DealItem alloc] initWithJSON:[json objectForKey:@"deal"]];
    [_deal retain];
    self.deal = _deal; 
    total_price = [[json objectForKey:@"total_price"] intValue];
	self.deal_title = [json objectForKey:@"deal_title"];
	self.store_name = [json objectForKey:@"store_name"];
	self.coupon_name = [json objectForKey:@"coupon_name"];
    self.status = [[json objectForKey:@"status"] intValue];
    self.count = [[json objectForKey:@"count"] intValue];
      self.purchase_time = [self getNSDateFromJSON:json andKey:@"purchase_time"];
    self.end_time = [self getNSDateFromJSON:json andKey:@"end_time"];
    
    Store *store = [[Store alloc] initWithJSONDictionary:[json objectForKey:@"store"]];
    self.imgPath = _deal.imgPath;
    NSLog(@"imgPath is %@", self.imgPath);
    self.store_address = store.store_address;
    self.store_address2= store.store_address2;
    self.x = store.x;
    self.y = store.y;
    self.phone = store.phone;
    [store release];
    serverHelper = [[ServerHelper alloc] initWithDelegate:self];
    return self;
}

- (void)dealloc
{
    [serverHelper dealloc];
    [super dealloc];
}

- (UIImage*)getImage
{
	return [deal getSqImage];
}

- (NSString*)getRemainTime
{
    //사용한거는 사용함 이라고 표시 해줘야 함
	NSTimeInterval interval = [end_time timeIntervalSinceNow];
	NSString* result = nil;
    
    if([[self getStatusString] isEqualToString:@"사용"])
        return @"사용함";
    
	if (interval <= 0)
	{
		result = @"사용시간 만료";
	}
	else
	{
		int remainTime = (int)interval;
		int mm = (remainTime / 60) % 60;
		int HH = remainTime / 60 / 60;
		
		if (HH > 0)	result = [NSString stringWithFormat:@"%d시간 뒤 마감", HH];
		else		result = [NSString stringWithFormat:@"%d분 뒤 마감", mm];
	}

	return result;
}

- (NSString*)getStatusString
{
    switch ( status ) {
        case TRANSACTION_ORDERED:
            return @"미사용";
        case TRANSACTION_PREORDERED:
            return @"미결제";
        case TRANSACTION_USED:
            return @"사용";
        case TRANSACTION_CANCELED :
            return @"자동취소";
        default:
            return @"N/A";
    }
}

- (BOOL)hasLoadedThumbnail
{
    return (thumbnail != nil);
}

- (void)server_loadImage:(NSURL *)_url
{
    NSString *url = [NSString stringWithFormat:@"%@%@", _url, @DEALIMAGE_SQUARE];
    NSLog(@"url is %@",url);
    [serverHelper loadImageURL:url];
}


#pragma mark -
#pragma mark Overridden setters

- (UIImage *)thumbnail
{
    if (thumbnail == nil)
    {
        NSURL *url = [NSURL URLWithString:[self imgPath]];
        [self server_loadImage:url];
    }
    return thumbnail;
}


#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    UIImage *remoteImage = [[UIImage alloc] initWithData:responseData];
    self.thumbnail = remoteImage;
    // TODO something
    [delegate didLoadImage:remoteImage];
    NSLog(@"ServerOperationSuccess %@", [url absoluteString] );
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString *)errMsg
{
    NSLog(@"ServerOperationFail");
}



@end
