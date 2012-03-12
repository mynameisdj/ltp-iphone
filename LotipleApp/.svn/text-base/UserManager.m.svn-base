//
//  User.m
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import "UserManager.h"

#import "JSONKit/JSONKit.h"
#import "OAuthConsumer/OAuthConsumer.h"
#import "ServerUrls.h"
#import "ServerHelper.h"
#import "ServerConnection.h"
#import "Settings.h"
#import "LTPConstant.h"
#import "TranManager.h"
#import "DataManagerDelegate.h"

@implementation UserManager

@synthesize name, mobile, email, point, nickname, _id, delegate;

UserManager* _user;

+ (id)instance
{
	if (!_user)
	{
		_user = [[UserManager alloc] init] ;
	}
	return _user;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		serverHelper = [[ServerHelper alloc] initWithDelegate:self];
	}
	
	return self;
}

- (void)setDataWithDic:(NSDictionary*)jsonDic
{
    self._id = [[jsonDic objectForKey:@"_id"] intValue];
    NSLog(@"self id is %d ", self._id);
    self.nickname = [jsonDic objectForKey:@"nickname"];
	self.name = [jsonDic objectForKey:@"name"];
	self.mobile = [jsonDic objectForKey:@"mobile"];
	self.email = [jsonDic objectForKey:@"email"];
    self.point = [[jsonDic objectForKey:@"point"] intValue];
}

- (void)setData:(NSData*)jsonData
{
	NSDictionary *items = [[JSONDecoder decoder] objectWithData:jsonData];
	NSDictionary* user = [items objectForKey:@"user"];
    [self setDataWithDic:user];
}

- (BOOL)server_login:(NSString*)login_id password:(NSString*)password delegate:(NSObject<DataManagerDelegate>*)__delegate
{

    [self setDelegate:__delegate];
    [serverHelper sendLoginRequest:login_id password:password];
	return YES;
}

- (void)logout
{
    [self server_registerDeviceToken:@""];
    [[ServerConnection instance] initRequestToken] ;
    [[TranManager instance] removeTran];
    [[Settings instance] save];
 }


- (void)server_fillUserInfo
{
    [serverHelper sendOAuthRequestURL:@USER_INFO_REQUEST andParams:nil];
}

-(void)handle_userinfo:(NSData*)responseData
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSDictionary *response_data = [response_all objectForKey:@"data"];
    NSDictionary* user = [response_data objectForKey:@"user"];
    [self setDataWithDic:user];
    if ( [delegate respondsToSelector:@selector(didDataUpdateSuccess)] ) 
    {
        [delegate didDataUpdateSuccess];
    }
}

-(void)server_registerDeviceToken:(NSString*)deviceToken
{
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
    [params setObject:deviceToken forKey:@"device_token"];
    [params setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"app_version"];
    [serverHelper sendOAuthRequestURL:@USER_REGISTER_DEVICE_TOKEN_REQUEST andParams:params];
}
-(void)registerDeviceToken
{
    NSString* _deviceToken = [[ServerConnection instance] deviceToken];
    if ( _deviceToken )
        [self server_registerDeviceToken:_deviceToken];
}


-(void)handle_login
{
    [self server_fillUserInfo];
    // login 성공 후
    [self registerDeviceToken];
   
}

-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@LOGIN_ACCESS_TOKEN].location != NSNotFound )
    {
        [self handle_login];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@USER_INFO_REQUEST].location != NSNotFound )
    {
        [self handle_userinfo:responseData];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@USER_REGISTER_DEVICE_TOKEN_REQUEST].location != NSNotFound )
    {
        ; // do nothing
    }
    NSAssert(true,@"source code should not reach here");
    
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] isEqualToString:@LOGIN_ACCESS_TOKEN] )
    {
        errMsg = [NSString stringWithFormat:@"로그인 실패 : %@", errMsg];
    }
    else if ( [[chunks objectAtIndex:0] isEqualToString:@USER_INFO_REQUEST] )
    {
        errMsg = [NSString stringWithFormat:@"유저 정보 얻어오기 실패 : %@", errMsg];
    }
    else if ( [[chunks objectAtIndex:0] isEqualToString:@USER_REGISTER_DEVICE_TOKEN_REQUEST] )
    {
        errMsg = [NSString stringWithFormat:@"디바이스 등록 실패 : %@", errMsg];
    }
    if ( [delegate respondsToSelector:@selector(didDataUpdateFail:)] ) 
    {
        [delegate didDataUpdateFail:errMsg];
    }



}



-(void)dealloc
{
    [serverHelper release];
    [super dealloc];
}


@end
