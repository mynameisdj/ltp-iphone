//
//  ServerConnection.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 18..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerOperationDelegate.h"


@class OAToken;
@class Deal;
@class DealItem;

@interface ServerConnection : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate >
{
	NSString* serverUrl;

	NSString* usedId;
	NSString* usedPw;
    NSString* _deviceToken;
	
	OAToken* requestToken;

	CLLocationManager* locationManager;
	CLLocation* lastLocation;
	NSMutableSet* locationListeners;
	NSMutableSet* locationListenersPurgeQueue;
		
	// for blocking (NOT threadsafe!!)
	BOOL signal;
	NSData* lastResponse;
	NSError* lastError;	

	NSMutableDictionary* imageCache;
	NSLock* cacheLock;
    
    // 서버에서 받아온 아이폰 최신 버전
    float newIphoneAppVer;
    
    // 공지사항
    NSString* serverMsg;
    
    // 구매옵션 개수 ( 신용카드, 포인트 -> 2) , 신용카드, 포인트, 모바일 -> 3 
    int purchaseOptionCnt;
    
    
    // 개발용인지 여부
    BOOL developMode;
    
    // 친구추천 이벤트중인가
    BOOL eventMode;
    
    // 위도, 경도 
    double cur_lat, cur_lng;
    
    // 이벤트 최근 업데이트 시간
    NSDate* lastEventUpdateTime;
    
    NSMutableArray *areaArray;
    NSObject<ServerOperationDelegate> *delegate;
    
}
@property (nonatomic, assign) int purchaseOptionCnt;
@property (nonatomic, assign) BOOL developMode, eventMode;
@property (nonatomic, retain) NSString* serverUrl;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* lastLocation;
@property (nonatomic, assign) double cur_lat, cur_lng;
@property (nonatomic, retain) OAToken* requestToken;
@property (nonatomic, retain) NSDate* lastEventUpdateTime;

@property BOOL signal;
@property (nonatomic, copy) NSString* serverMsg;
@property (nonatomic, assign) float newIphoneAppVer;
@property (nonatomic, copy) NSData* lastResponse;
@property (nonatomic, retain) NSError* lastError;

@property (nonatomic, copy) NSString* usedId;
@property (nonatomic, copy) NSString* usedPw;
@property (nonatomic, retain) NSMutableArray *areaArray; 
@property (nonatomic, copy) NSString* deviceToken;
@property (nonatomic, retain) NSObject<ServerOperationDelegate> *delegate;

+ (ServerConnection *)instance;
- (BOOL)logged;
- (void)setDebugMode;
- (void)initRequestToken;
- (NSString*)registerSubmit:(NSString*)email name:(NSString*)name
				mobile:(NSString*)mobile password:(NSString*)password
                  birthYear:(int)selectedBirthYear gender:(int)selectedGender;
- (NSString*)confirmPhoneNumber:(NSString*)mobile confirmNumber:(NSString*)confirmNumber;
- (BOOL)registerLike:(int)store_id;
- (BOOL)submitTransaction:(int)tran_id;
- (int)getDealVariantInfo:(int)deal_id;
- (NSString*)getDealPurchaseAvailable:(int)deal_id;

- (UIImage*)getImg:(NSString*)imgPath fileName:(NSString*)fileName;
- (UIImage*)getSqImg:(NSString*)imgPath;
- (UIImage*)getStoreImg:(NSString*)imgPath;
- (NSArray*)getDealDetailImg:(DealItem*)deal;
- (NSMutableArray*)getAreaArray;
- (BOOL)locationServicesEnabled;
- (void)startUpdatingLocation;
- (float)getDistance:(DealItem*)deal;
- (void)procLotipleApi:(NSDictionary*)params;
- (void)addLocationListener:(id<CLLocationManagerDelegate>)listener;
- (void)removeLocationListener:(id<CLLocationManagerDelegate>)listener;
- (NSString*) sha256:(NSString*)input;
- (void)showAlertIfAppisOutdate;
@end
