//
//  TranManager.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import "TranManager.h"
#import "Store.h"
#import "Tran.h"
#import "ServerConnection.h"
#import "LotipleAppAppDelegate.h"
#import "JSONKit.h"
#import "ServerUrls.h"
#import "ServerHelper.h"
#import "LTPConstant.h"
#import "ServerOperationDelegate.h"

@implementation TranManager
@synthesize tranList, delegate;
TranManager* _tranmanager;
+ (id) instance
{
    @synchronized (self) {
        if ( !_tranmanager ) 
        {
            _tranmanager = [[TranManager alloc] init];
        }
    }
    return _tranmanager;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        tranList = [[NSMutableArray alloc] init];
        serverHelper = [[ServerHelper alloc] initWithDelegate:self];
    }
   
    return self;
}

- (void)dealloc
{
    [tranList release];
    [serverHelper release];
    [super dealloc];
}

- (void)removeTran
{
    [tranList removeAllObjects];
}


-(void)appendTranToList:(NSArray*)tranListFromServer
{
    [tranList removeAllObjects];
    int count = [tranListFromServer count];
    for ( int i = 0 ; i< count ; i++)
    {
        id tran = [tranListFromServer objectAtIndex:i];
        Tran* newTran = [[Tran alloc] initWithJSON:tran];
        [tranList addObject:newTran];
        [newTran release];
    }
}
#pragma mark - server op
-(void)server_refreshTranList
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:@"20" forKey:@"number"]; // TODO : should show more than that
    [params setObject:@"1" forKey:@"page"];
    NSString* url = @TRAN_LIST_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
    [params release];    
    
    // TODO
    /*
     model 로부터 리스트를 읽어와서 우선적으로 Tranmanager에 반영시켜주고
     그 해당 리스트를 myTransaction으로 post 해주어 로컬에서도 
     가장 마지막에 액세스한 쿠폰의 상태를 볼 수 있도록 한다.
     */
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString* response_code = [response_all objectForKey:@"code"];
    if ( [@"NEED_LOGIN" isEqualToString:response_code ] )
    {
        if ([delegate respondsToSelector:@selector(didDataUpdateFail)])
        {
            [delegate didDataUpdateFail:@"구매내역을 보기 위해서는 로그인이 필요합니다."];
        }
    }
    
    NSDictionary *response_data = [response_all objectForKey:@"data"];
    NSArray* tran_list = [response_data objectForKey:@"transaction_list"];
    [self appendTranToList:tran_list];
    if ([delegate respondsToSelector:@selector(didDataUpdateSuccess)])
    {
        [delegate didDataUpdateSuccess];
    }
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    // TODO : 인터넷이 안되는 상황과 로그인이 필요한 상황의 구분 필요
    if ([delegate respondsToSelector:@selector(didDataUpdateFail)])
    {
        [delegate didDataUpdateFail:@"네트워크 연결에 문제가 있습니다."];
    }
}

@end
