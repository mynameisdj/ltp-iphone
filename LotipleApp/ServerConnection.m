//
//  ServerConnection.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 18..
//  Copyright 2011 Home. All rights reserved.
//

#import "ServerConnection.h"

#import "JSONKit/JSONKit.h"
#import "OAuthConsumer/OAuthConsumer.h"

#import "DealItem.h"
#import "TranManager.h"
#import "DealItem.h"
#import "UserManager.h"
#import "LotipleAppAppDelegate.h"
#import "ListViewController.h"
#import "Area.h"
#import "Settings.h"
#import "TextUtil.h"
#import "Util.h"
#import "LTPConstant.h"
#import <CommonCrypto/CommonDigest.h>

#define POPTION_POINT 1
#define POPTION_MOBILE 2
#define dbltoint(x) (int)(x*1000000)

@implementation ServerConnection

@synthesize serverUrl, locationManager, lastLocation, purchaseOptionCnt;
@synthesize requestToken;
@synthesize signal, lastResponse, lastError, lastEventUpdateTime;
@synthesize usedId, usedPw , newIphoneAppVer, serverMsg, areaArray;
@synthesize developMode, eventMode, cur_lat, cur_lng, delegate;
@synthesize deviceToken=_deviceToken;


static ServerConnection* _serverConnection;

+ (ServerConnection *)instance
{	
    @synchronized(self) {
        if (!_serverConnection)
        {
            _serverConnection = [[ServerConnection alloc] init];
        }
	}
	return _serverConnection;
}

- (BOOL)logged
{
    NSString* key = [requestToken key];
    NSString* secret = [requestToken secret];
    NSLog(@"key %@ secret %@", key, secret);
    if ([key isEqualToString:@DEFAULT_KEY] && [secret isEqualToString:@DEFAULT_SECRET])
    {
        return NO;
    }
    return YES;
}

- (void)setCurrentAppVer
{
    NSString *appVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [appVersionStr floatValue];
}
- (void)initRequestToken
{
    [self.requestToken setKey:@DEFAULT_KEY];
    [self.requestToken setSecret:@DEFAULT_SECRET];
    [[Settings instance] setTokenKey:@DEFAULT_KEY];
    [[Settings instance] setTokenSecret:@DEFAULT_SECRET];
}
- (void)loadFromFile
{
    Settings* settings = [Settings instance];
    if ( [settings tokenKey] == nil ) 
    {
        self.requestToken = [[OAToken alloc ] initWithKey:@DEFAULT_KEY secret:@DEFAULT_SECRET]; 
    }
    else 
    {
        self.requestToken = [[OAToken alloc ] initWithKey:[settings tokenKey] secret:[settings tokenSecret]]; 
    }
    if ( [settings developMode] == YES )
        self.developMode = YES;
    else
        self.developMode = NO;
}

- (id)init
{
    NSLog(@"Server Init begins...");
	self = [super init];
    developMode = YES;
    eventMode = NO;
    cur_lat = 37.498185; 
    cur_lng = 127.027574;
    delegate = nil;
    [self setCurrentAppVer];
    [self loadFromFile];
	if (self)
	{
        if( developMode )
        {
            serverUrl = @"http://qa.lotiple.com";
        }
        else
        {
            serverUrl = @"https://www.lotiple.com";
        }
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = 100.0f;
        [locationManager startUpdatingLocation];
        
		locationListeners = [[NSMutableSet alloc ] initWithCapacity:5];
		locationListenersPurgeQueue = [[NSMutableSet alloc] initWithCapacity:5];
		

		imageCache = [[NSMutableDictionary alloc] initWithCapacity:10];
		cacheLock = [[NSLock alloc] init];
        
        _deviceToken = nil;
    }

	return self;
}

- (void)showAlertIfAppisOutdate
{
    NSString *appVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    float appVersion = [appVersionStr floatValue];
    if ( newIphoneAppVer > appVersion + 0.0001 ) {
        NSLog(@"업데이트하세영 - latestAppVersion :%f appVersion : %f" , newIphoneAppVer, appVersion);
        [Util showUpdateConfirmView:self message:@"최신버전은 정말 좋은데 어떻게 표현할 방법이 없네요. 직접 말하기도 그렇고..."];
    }
    else {
        NSLog(@"업데이트필요없음 - latestAppVersion :%f appVersion : %f" , newIphoneAppVer, appVersion);
    }
}


- (void)dealloc
{
	[lastError release];
	[locationListeners release];
	[locationListenersPurgeQueue release];
	[locationManager release];
	
	[cacheLock release];
	[imageCache release];	
	[super dealloc];
}

#pragma mark - Login


#pragma mark - Lotiple OAUTH/API

- (void)procLotipleApi:(NSDictionary*)params
{
	[LotipleAppAppDelegate showBusyIndicator:YES];

	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@CONSUMER_KEY
													secret:@CONSUMER_SECRET];
	
	NSString* url = [NSString stringWithFormat:@"%@/oauth/api", serverUrl];
	NSString* urlForSign = [NSString stringWithFormat:@"%@:8080/oauth/api", serverUrl];
    NSLog(@"before request url is %@" , url );
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
																	signURL:urlForSign
																   consumer:consumer
																	  token:self.requestToken
																	  realm:nil
														  signatureProvider:nil];
	
    NSLog(@"AFTER request");
	NSString* post = @"";
	for (id key in params)
	{
		if (![post isEqualToString:@""])
			post = [post stringByAppendingString:@"&"];
		
		id value = [params objectForKey:key];
		post = [post stringByAppendingFormat:@"%@=%@", key, value];
	}
	NSLog(@"post - %@", post );
	NSData* postData = [post dataUsingEncoding:NSUTF8StringEncoding];
	NSString* postLength = [NSString stringWithFormat:@"%d", [postData length]];

	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	self.signal = NO;
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(apiFuncTicket:didFinishWithData:)
				  didFailSelector:@selector(apiFuncTicket:didFailWithError:)];
	
	[consumer release];
	[request release];	
	[fetcher release];
	
	// blocking
	while (!self.signal)
	{
		sleep(100);
	}
	
    
	[LotipleAppAppDelegate showBusyIndicator:NO];
}

- (void)apiFuncTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	self.signal = YES;
	self.lastError = nil;
	self.lastResponse = nil;

	if (ticket.didSucceed)
	{
		self.lastResponse = data;

		NSString* responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];

		//NSLog(@"ApiFunc - \"%@\"", responseBody);
		[responseBody release];
	}
	else
	{
		NSLog(@"Finish but did not succeed.");
	}
}

- (void)apiFuncTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	self.signal = YES;
	self.lastError = error;
	self.lastResponse = nil;
	
	NSLog(@"Error: %@", [error localizedDescription]);
}


#pragma mark - userInfo

- (NSString*)registerSubmit:(NSString*)email name:(NSString*)name
				mobile:(NSString*)mobile password:(NSString*)password
                  birthYear:(int)selectedBirthYear gender:(int)selectedGender
{
	NSString* url = [NSString stringWithFormat:@"%@/jsp/user/register_submit.jsp", serverUrl];
	NSString* param = [NSString stringWithFormat:@"email=%@&name=%@&mobile=%@&password=%@&sex=%d&birthyear=%d",
					   email, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], mobile, password,  selectedGender, selectedBirthYear];
	NSString* param2 = @"favorite_area=1&register_type=buyer&agree_adv_sms=1&agree_adv_email=1";

	[LotipleAppAppDelegate showBusyIndicator:YES];
    
	NSString* query = [NSString stringWithFormat:@"%@?%@&%@", url, param, param2];
    NSLog(@"회원가입 쿼리 - %@", query);
	NSData* resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];	

	[LotipleAppAppDelegate showBusyIndicator:NO];

	// 결과 처리
	NSString* result = [[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] autorelease];
	result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSLog(@"register_submit - \"%@\"", result);
	
	return result;
}

- (NSString*)confirmPhoneNumber:(NSString*)mobile confirmNumber:(NSString*)confirmNumber
{
    NSString* url = [NSString stringWithFormat:@"%@/jsp/user/phone_authentication.jsp", serverUrl];
    NSString* param;
    if( confirmNumber )
        param = [NSString stringWithFormat:@"mobile=%@&verify_num=%@", mobile, confirmNumber];
    else
        param = [NSString stringWithFormat:@"mobile=%@&dup_check=true", mobile];
    
    NSString* query = [NSString stringWithFormat:@"%@?%@", url, param];
    NSLog(@"휴대폰인증 - %@", query);
    
    [LotipleAppAppDelegate showBusyIndicator:YES];
    
    NSData* resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:query]];
    
    [LotipleAppAppDelegate showBusyIndicator:NO];
    
    NSString* result = [[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] autorelease];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"confirmNumber result - \"%@\"", result);
    
    return result;
}

#pragma mark - Like & Trans

- (BOOL)registerLike:(int)store_id
{
	NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
	
	[params setObject:@"like_register" forKey:@"func"];
	[params setObject:[NSString stringWithFormat:@"%d", store_id] forKey:@"store_id"];
	
	[self procLotipleApi:params];
	
	// 결과 처리
	NSString* result = nil;
	
	if (lastResponse)
	{
		NSDictionary* items = [[JSONDecoder decoder] objectWithData:lastResponse];
		result = [items objectForKey:@"result"];
	}
	else if (lastError)
	{
		result = [lastError localizedDescription];
	}

	BOOL succeed = NO;
	NSString* message = nil;
	
	if ([result isEqualToString:@"OK"])
	{
		succeed = YES;
		message = @"좋아하는 상점에 추가하였습니다";
	}
	else if ([result isEqualToString:@"NEED_LOGIN"])
	{	
		message = @"로그인이 필요합니다";
	}
	else if ([result isEqualToString:@"INVALID_STORE"])
	{
		message = @"잘못된 상점입니다";
	}
	else if ([result isEqualToString:@"ERROR"])
	{
		message = @"오류";
	}
	else if ([result isEqualToString:@"ALREADY_LIKE"])
	{
		message = @"이미 좋아하는 상점으로 등록되어있습니다";
	}
	else
	{
		message = result;
	}
	
	if (message)
	{
		[Util showAlertView:nil message:message];
	}
	
	return succeed;
}

- (BOOL)submitTransaction:(int)tran_id
{
	NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
	
	[params setObject:@"trans_submit" forKey:@"func"];
	[params setObject:[NSString stringWithFormat:@"%d", tran_id] forKey:@"transaction_id"];
	
	[self procLotipleApi:params];
	
	// 결과 처리
	NSString* result = nil;
	
	if (lastResponse)
	{
		NSDictionary* items = [[JSONDecoder decoder] objectWithData:lastResponse];
		result = [items objectForKey:@"return code"];
	}
	else if (lastError)
	{
		result = [lastError localizedDescription];
	}
    
    NSString* message = nil;
    
    NSLog(@"*********** result is [%@]",result );
    
	if ([result isEqualToString:@"OK"])
	{	
		return YES;
	}
    else
    {
		message = [NSString stringWithFormat:@"상품구입중 문제 발생했습니다. %@" , result ];
        [Util showAlertView:self message:message];
        return NO;
    }
}


#pragma mark - Deal

- (UIImage*)getImg:(NSString*)imgPath fileName:(NSString*)fileName
{	
	[cacheLock lock];
    if ( serverUrl == nil || imgPath == nil || fileName == nil )
    {
        return nil;
    }
	NSString* url = [NSString stringWithFormat:@"%@%@%@", serverUrl, imgPath, fileName];
    NSLog(@"url is %@", url);
	UIImage* image = [imageCache objectForKey:url];	
	if (!image)
	{
		[LotipleAppAppDelegate showBusyIndicator:YES];

		NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
		image = [[[UIImage alloc] initWithData:imgData] autorelease];
		if (image)
		{			
			[imageCache setObject:image forKey:url];
			//NSLog(@"getting image : %@ - from web", url);
		}
		else
		{
			//NSLog(@"getting image : %@ - from web - but failed", url);
		}
	
		[LotipleAppAppDelegate showBusyIndicator:NO];	
	}
	else
	{
		//NSLog(@"getting image : %@ - cached", url);
	}
	
	[cacheLock unlock];
	return image;
}


// TODO : should be deleted 
- (UIImage*)getSqImg:(NSString*)imgPath
{
	NSString* fileName = @"deal_sq_m.jpg";	
	return [self getImg:imgPath fileName:fileName];
}

- (UIImage*)getStoreImg:(NSString*)imgPath
{
	NSString* fileName = @"store.jpg";
	return [self getImg:imgPath fileName:fileName];
}

- (NSArray*)getDealDetailImg:(DealItem*)deal
{
	NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
	
	NSString* metaUrl = [NSString stringWithFormat:@"%@/json/image_list.jsp?type=deal&id=%d", serverUrl, deal._id];
	NSLog(@"%@", metaUrl);
	
	NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:metaUrl]];
	if (jsonData)
	{
		NSDictionary *items = [[JSONDecoder decoder] objectWithData:jsonData];

		id value_imgs = [items objectForKey:@"imgs"];
		
		if ([value_imgs isKindOfClass:[NSArray class]])
		{
			NSArray* imgs = value_imgs;
		
			int imgCount = [imgs count];	
			for (int i = 1 ; i < imgCount ; i++)
			{
				NSDictionary* img = [imgs objectAtIndex:i];
				NSString* imgpath = [img objectForKey:@"path"];
                NSLog(@"%@", imgpath);
				UIImage* image = [self getImg:imgpath fileName:@"detail_m.jpg"];
				
                if ( image )
				{
					[result addObject:image];
				}
			}
		}
	}
	else
	{
		NSString* message = @"서버로부터 이미지 파일 정보를 얻어올 수 없습니다";
		[Util showAlertView:self message:message];
	}
	
	return result;
}

- (int)getDealVariantInfo:(int)deal_id
{
    NSString* metaUrl = [TextUtil getURLwithOAuthInfo:@"/json/deal_detail_variant.jsp"];
    metaUrl = [NSString stringWithFormat:@"%@&deal_id=%d&x=%d&y=%d&route=2", metaUrl, deal_id, dbltoint(cur_lng), dbltoint(cur_lat)];
	NSLog(@"%@", metaUrl);
	
	NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:metaUrl]];
    
    if ( jsonData )
    {
        NSDictionary *items = [[JSONDecoder decoder] objectWithData:jsonData];
        NSString *ret_str = [items objectForKey:@"current_ordered_count"];
        int ret = [ret_str intValue];
        return ret; 
    }
    else
    {
        /*
        NSString* message = @"서버로부터 딜 정보를 얻어올 수 없습니다";
		[LotipleAppAppDelegate showAlertView:self message:message];
        */
        return -1;
    }
}


- (NSString*)getDealPurchaseAvailable:(int)deal_id
{
    NSString* metaUrl = [NSString stringWithFormat:@"%@/json/checkPurchaseAvailable.jsp?deal_id=%d", serverUrl, deal_id];
	NSLog(@"%@", metaUrl);
	
	NSData* jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:metaUrl]];
    
    if ( jsonData )
    {
        NSDictionary *items = [[JSONDecoder decoder] objectWithData:jsonData];

        NSString *result_str = [items objectForKey:@"result"];        
        NSString *msg = [items objectForKey:@"msg"];
        
        if([result_str isEqualToString:@"OK"])
            return @"OK";
        else {
            return msg;
        }
    }
    
    return @"딜 상태를 가져오지 못했습니다.";
}




# pragma mark - location

- (BOOL)locationServicesEnabled
{
	return [CLLocationManager locationServicesEnabled];
}

- (void)startUpdatingLocation
{
	return [locationManager startUpdatingLocation];
}

- (float)getDistance:(DealItem*)deal
{
  
    //NSLog(@"getdistance");
   	if (![self locationServicesEnabled])
	{
      
		return 0.0f;
	}
	float latitude = [deal lat];
	float longitude = [deal lng];
	CLLocation* dealLoc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	
    if (lastLocation == nil || ![lastLocation isKindOfClass:[CLLocation class]]) {
        lastLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    }
	// meter

    CLLocationDistance distance = [lastLocation distanceFromLocation:dealLoc];
    [dealLoc release];
    return distance;
}

- (void)addLocationListener:(id<CLLocationManagerDelegate>)listener
{
	[locationListeners addObject:listener];
}

- (void)removeLocationListener:(id<CLLocationManagerDelegate>)listener
{
	[locationListenersPurgeQueue addObject:listener];
}


#pragma mark - CLLocationManagerDelegate

//위치가 변경되었을때 호출.
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
	MKCoordinateRegion region;
	region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000);
	
	
	[self.locationManager stopUpdatingLocation];
	
	[lastLocation release];
	lastLocation = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    

	// purge - pre chaining
	[locationListeners minusSet:locationListenersPurgeQueue];
	[locationListenersPurgeQueue removeAllObjects];
	
	for (id<CLLocationManagerDelegate> delegate_ in locationListeners)
	{
		[delegate_ locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
	}

	// purge - post chaining
	[locationListeners minusSet:locationListenersPurgeQueue];
	[locationListenersPurgeQueue removeAllObjects];
    
    // 현재 좌표 저장 
    CLLocation *this_location = [locationManager location];
    cur_lat = [this_location coordinate].latitude;
    cur_lng = [this_location coordinate].longitude;
}

//위치를 못가져왔을때 에러 호출.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"locationManager error!!!");
    for (id<CLLocationManagerDelegate> delegate_ in locationListeners)
	{
		[delegate_ locationManager:manager didFailWithError:error];
	}
}


#pragma mark - Misc
-(void)setDebugMode
{
    Settings* set_int = [Settings instance];
    if ( self.developMode == YES )
    {
        self.developMode = NO;
        [set_int setDevelopMode:NO];
        
        [Util showAlertView:nil message:@"실 서버로 변경합니다. 앱을 재시작해주세요."];
    }
    else
    {
        self.developMode = YES;
        [set_int setDevelopMode:YES];
        [Util showAlertView:nil message:@"개발 서버를 변경합니다. 앱을 재시작해주세요."];
    }
}

- (NSMutableArray*)getAreaArray
{
    return areaArray;
}


-(NSString*) sha256:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [alertView.title isEqualToString:@UPDATE_ALERT_LABEL] ) 
    {
        if ( buttonIndex == 1 )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@UPDATE_URL_LOTIPLE_APP]];
        }
    }
}



@end
