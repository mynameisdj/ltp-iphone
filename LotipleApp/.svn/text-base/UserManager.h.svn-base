//
//  User.h
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHelper.h"
#import "DataManagerDelegate.h"

@interface UserManager : NSObject <ServerOperationDelegate>
{
	int _id;
	NSString* name;
	NSString* mobile;
	NSString* email;
    NSString* nickname;
    int point;
    NSObject<DataManagerDelegate> *delegate;
    ServerHelper* serverHelper;
}

@property int point, _id;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, retain) NSObject<DataManagerDelegate> *delegate;

+ (id)instance;
- (void)setDataWithDic:(NSDictionary*)jsonDic;
- (void)setData:(NSData*)jsonData;
- (BOOL)server_login:(NSString*)login_id password:(NSString*)password delegate:(NSObject<DataManagerDelegate>*)__delegate;
- (void)logout;
- (void)server_fillUserInfo;
-(void)registerDeviceToken;
-(void)server_registerDeviceToken:(NSString*)deviceToken;
@end
