//
//  DealItem.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import "DealItem.h"
#import "AreaManager.h"
#import "LTPConstant.h"
#import "ServerConnection.h"
#import "ServerHelper.h"
#import "ServerUrls.h"
#import "ImageCacheManager.h"


@implementation DealItem
// float
@synthesize lng, lat, distance;
// NSString*
@synthesize title, store_name, subtitle, description, imgPath, area_name;
// int 
@synthesize discount_rate, price, reduced_price, area_code, store_id, _id, like, current_ordered_count, max_count, count_limit, category;
// UIImage for listview 
@synthesize thumbnail;
// delegate
@synthesize delegate;

- (id)initWithJSON:(NSDictionary*)json
{
    self = [super init];
	self.area_code = [[json objectForKey:@"area_code"] intValue];
    self.area_name = [[AreaManager instance] getAreaName:area_code ];
	_id = [[json objectForKey:@"_id"] intValue];
	original_id = [[json objectForKey:@"original_id"] intValue];
	NSLog(@" %@ ",[json objectForKey:@"title"] );
	self.title = [json objectForKey:@"title"];
	self.subtitle = [json objectForKey:@"subtitle"];
	self.description = [json objectForKey:@"description"];
	
	price = [[json objectForKey:@"price"] intValue];
	reduced_price = [[json objectForKey:@"reduced_price"] intValue];
	discount_rate = [[json objectForKey:@"discount_rate"] intValue];
	
	current_ordered_count = [[json objectForKey:@"current_ordered_count"] intValue];
	
	count_limit = [[json objectForKey:@"count_limit"] intValue];
	max_count = [[json objectForKey:@"max_count"] intValue];
	min_count = [[json objectForKey:@"min_count"] intValue];
	
	store_id = [[json objectForKey:@"store_id"] intValue];
	store_commission = [[json objectForKey:@"store_commission"] floatValue];
	self.store_name = [json objectForKey:@"store_name"];

	NSTimeInterval timestamp = [[json objectForKey:@"creation_time"] doubleValue] / 1000;
	creation_time = [[NSDate dateWithTimeIntervalSince1970:timestamp] retain];
    
	timestamp = [[json objectForKey:@"start_time"] doubleValue] / 1000;
	start_time = [[NSDate dateWithTimeIntervalSince1970:timestamp] retain];
    
	timestamp = [[json objectForKey:@"end_time"] doubleValue] / 1000;
	end_time = [[NSDate dateWithTimeIntervalSince1970:timestamp] retain];
	
	category = [[json objectForKey:@"category"] intValue];
	status = [[json objectForKey:@"status"] intValue];
	
	lng = [[json objectForKey:@"x"] intValue] / 1000000.0f;
	lat = [[json objectForKey:@"y"] intValue] / 1000000.0f;
	
	self.imgPath = [json objectForKey:@"img"];
    NSLog(@"imgPath is %@", self.imgPath);
	like = [[json objectForKey:@"like"] intValue];
    distance = [[ServerConnection instance] getDistance:self];
    islike = [[json objectForKey:@"is_like"] boolValue];
    serverHelper = [[ServerHelper alloc] initWithDelegate:self];
	return self;
}

- (void)dealloc
{
    [serverHelper dealloc];
    [super dealloc];
}

- (BOOL)isDealStarted
{
    NSTimeInterval remainToStart = [start_time timeIntervalSinceNow];
    if( remainToStart <= 0 )
        return YES;
    return NO;
}

- (NSString*)getRemainTime
{
	NSString* result = nil;
    
	
    if ( status == DEAL_STATUS_STOP )
        return @"중지";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];

//    NSTimeInterval remainToStart = [start_time timeIntervalSinceNow];
//	// 시작했음!
//	if (remainToStart <= 0)
//	{
//		NSTimeInterval remainToEnd = [end_time timeIntervalSinceNow];
//		
//		// 마감됐음
//		if (remainToEnd <= 0)
//		{
//			result = @"마감";
//		}
//		else
//		{
//			int remainTime = (int)remainToEnd;
//			int mm = (remainTime / 60) % 60;
//			int HH = remainTime / 60 / 60;
//            
//			if (HH > 0)	result = [NSString stringWithFormat:@"%d시간 뒤 마감", HH];
//			else		result = [NSString stringWithFormat:@"%d분 뒤 마감", mm];
//		}
//	}
//	// 아직 시작하지 않았음!
//	else
//	{
//		int remainTime = (int)remainToStart;
//		int mm = (remainTime / 60) % 60;
//		int HH = remainTime / 60 / 60;
//        
//		if (HH > 0)	result = [NSString stringWithFormat:@"%d시간 뒤 시작", HH];
//		else		result = [NSString stringWithFormat:@"%d분 뒤 시작", mm];
//	}
    
    result = [NSString stringWithFormat:@"%@ ~ %@", [df stringFromDate:start_time], [df stringFromDate:end_time]];
    [df release];
	return result;
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    UIImage *remoteImage = [[UIImage alloc] initWithData:responseData];
    self.thumbnail = remoteImage;
    // TODO something
    [[ImageCacheManager instance] saveImageCacheImg:responseData andUrl:[url absoluteString]];
    [delegate didLoadImage:remoteImage];

    NSLog(@"ServerOperationSuccess %@", [url absoluteString] );
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"ServerOperationFail");
}

#pragma mark - public method
- (BOOL)hasLoadedThumbnail
{
    return (thumbnail != nil);
}

- (BOOL)isDealStopped
{
    if ( status == DEAL_STATUS_STOP )
        return TRUE;
    return FALSE;
}

- (BOOL)isDealEnded
{
    NSTimeInterval remainToEnd = [end_time timeIntervalSinceNow];
    if ( remainToEnd <= 0 )
        return TRUE;
    return FALSE;
}


- (NSString*)getTimePeriod 
{
    NSString* result = nil;
    if ( [self isDealStopped] )
        return @"중지";
    if ( [self isDealEnded] )
        return @"마감";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[ [NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]  ];
    [df setDateFormat:@"HH:mm"];
    result = [NSString stringWithFormat:@"%@ ~ %@", [df stringFromDate:start_time], [df stringFromDate:end_time] ];  
    [df release];
    return result;
}


#pragma mark -
#pragma mark Private methods

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


#pragma mark Image Legacy Function for deal detail
// TODO :refactoring 


- (UIImage*)getSqImage
{
	return [[ServerConnection instance] getSqImg:imgPath];
}

- (NSArray*)getDetailImages
{
	return [[ServerConnection instance] getDealDetailImg:self];
}




@end
