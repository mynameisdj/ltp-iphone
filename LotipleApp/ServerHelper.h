//
//  ServerHelper.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 7. 29..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerOperationDelegate.h"


@interface ServerHelper : NSObject <UIAlertViewDelegate> 
{

    NSObject<ServerOperationDelegate> *delegate;
}

@property (nonatomic, retain) NSObject<ServerOperationDelegate> *delegate;
- (void)sendRequestURL:(NSString*)url andParams:(NSMutableDictionary*)params;
- (NSData*)sendSyncRequestURL:(NSString*)url andParams:(NSMutableDictionary*)params;
- (id)initWithDelegate:(NSObject<ServerOperationDelegate>*)__delegate;
- (void)loadImageURL:(NSString*)url;
- (void)sendOAuthRequestURL:(NSString*)url andParams:(NSMutableDictionary*)params;
- (void)sendOAuthRequestURL:(NSString*)url andParamStr:(NSString*)paramStr;
- (void)sendPostRequest:(NSString*)url andParams:(NSMutableDictionary*)params;
- (void)sendLoginRequest:(NSString*)login_id password:(NSString*)password;
@end
