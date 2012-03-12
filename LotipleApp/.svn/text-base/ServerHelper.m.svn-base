//
//  ServerHelper.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 7. 29..
//  Copyright 2011 Home. All rights reserved.
//

#import "ServerOperationDelegate.h"
#import "ServerHelper.h"
#import "ServerConnection.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ServerUrls.h"
#import "OAuthConsumer/OAuthConsumer.h"
#import "ServerConnection.h"
#import "ImageCacheManager.h"
#import "TextUtil.h"
#import "LotipleAppAppDelegate.h"
#import "Reachability.h"
#import "LTPConstant.h"
#import "Settings.h"
#import "Util.h"


@implementation ServerHelper
@synthesize delegate;

NSString* _serverUrl=@"";
NSString* paygateRequestKeys=@"mid paymethod goodname unitprice cardtype cardnumber cardexpireyear cardexpiremonth cardownernumber receipttoname receipttotel receipttoemail mb_serial_no";

- (id)initWithDelegate:(NSObject<ServerOperationDelegate>*)__delegate 
{
    self = [super init];
    [self setDelegate:__delegate];
    _serverUrl = [[ServerConnection instance] serverUrl];
    return self;
}
- (BOOL)checkReachability
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if ( r.isReachable == NO ) {
        [Util showAlertView:self message:@"네트워크가 연결되어있지 않습니다. 3G / Wifi 네트워크 연결을 확인해주세요."];
    }
    return r.isReachable;
}

- (void)sendLoginRequest:(NSString*)login_id password:(NSString*)password
{
    OAConsumer* consumer = [[OAConsumer alloc] initWithKey:@CONSUMER_KEY secret:@CONSUMER_SECRET];
	OAToken* token = [[OAToken alloc] initWithKey:@"test" secret:@"test"];

    NSString* url = [NSString stringWithFormat:@"%@%@", _serverUrl , @LOGIN_ACCESS_TOKEN];
    
	OAMutableURLRequest* request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
																	signURL:nil
																   consumer:consumer
																	  token:token
																	  realm:nil
														  signatureProvider:nil];
    [token release];
    
	[request setHTTPMethod:@"POST"];
    
	[request setOAuthParameterName:@"x_auth_username" withValue:login_id];
	[request setOAuthParameterName:@"x_auth_password" withValue:password];
	[request setOAuthParameterName:@"x_auth_mode" withValue:@"client_auth"];
	
	OAAsynchronousDataFetcher* fetcher = [[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)didFailSelector:@selector(accessTokenTicket:didFailWithError:)] autorelease];
	[fetcher start];
	[consumer release];
	[request release];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{	
    NSURL* url = [[[NSURL alloc] initWithString:@LOGIN_ACCESS_TOKEN] autorelease];
    NSString* aStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"astr is %@", aStr);
    if (ticket.didSucceed)
	{
		NSString* responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		
		OAToken* token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];

        [[ServerConnection instance] setRequestToken:token];
        Settings* settings = [Settings instance];
        [settings setTokenKey:[token key]];
        [settings setTokenSecret:[token secret]];  
        
		[token release];
		[responseBody release];
        

        if ([delegate respondsToSelector:@selector(didServerOperationSuccess:andURL:)])
        {
            [delegate didServerOperationSuccess:nil andURL:url];
        }

       
		NSLog(@"Got Access Token [key:%@, secret:%@]", token.key, token.secret);
	}
	else
	{
        if ([delegate respondsToSelector:@selector(didServerOperationFail:andErrorMsg:)])
        {
            [delegate didServerOperationFail:url andErrorMsg:@"아이디와 패스워드를 확인해주세요."];
        }

	}

}
-
(void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
	NSLog(@"%s, Error: %@",__FUNCTION__, [error localizedDescription]);
    [Util showAlertView:nil message:@"네트워크가 불안합니다. 다시 시도해주십시오."];
}



- (void)sendOAuthRequestURL:(NSString*)url andParams:(NSMutableDictionary*)params
{	
    if ( ![self checkReachability] ) return;
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@CONSUMER_KEY
													secret:@CONSUMER_SECRET];
    OAToken* reqToken = [[ServerConnection instance] requestToken];
    NSLog(@"request token's key is %@ and secret is %@", [reqToken key], [reqToken secret]);
    url = [NSString stringWithFormat:@"%@%@", _serverUrl , url];
    NSLog(@"oAuth req url is %@ ", url);
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
																	signURL:url
																   consumer:consumer
																	  token:[[ServerConnection instance ]requestToken] 
																	  realm:nil
														  signatureProvider:nil];

    [params retain];
    NSString* paramStr = [TextUtil createParamString:params];
    NSLog(@"paramStr is %@", paramStr);
    NSData* postData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
	NSString* postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString* user_agent= [NSString stringWithFormat:@"Lotiple/Iphone %@", [TextUtil getVerStr] ];
    [request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:user_agent forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:postData];

    OAAsynchronousDataFetcher* fetcher = [[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(apiFuncTicket:didFinishWithData:)didFailSelector:@selector(apiFuncTicket:didFailWithError:)] autorelease];
	[fetcher start];
	[consumer release];
	[request release];
}


- (void)sendOAuthRequestURL:(NSString*)url andParamStr:(NSString*)paramStr
{	
    if ( ![self checkReachability] ) return;
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@CONSUMER_KEY
													secret:@CONSUMER_SECRET];
    OAToken* reqToken = [[ServerConnection instance] requestToken];
    NSLog(@"request token's key is %@ and secret is %@", [reqToken key], [reqToken secret]);
    url = [NSString stringWithFormat:@"%@%@", _serverUrl , url];
    NSLog(@"oAuth req url is %@ ", url);
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
																	signURL:url
																   consumer:consumer
																	  token:[[ServerConnection instance ]requestToken] 
																	  realm:nil
														  signatureProvider:nil];
    
    NSLog(@"paramStr is %@", paramStr);
    NSData* postData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
	NSString* postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString* user_agent= [NSString stringWithFormat:@"Lotiple/Iphone %@", [TextUtil getVerStr] ];
    [request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:user_agent forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:postData];
    
    OAAsynchronousDataFetcher* fetcher = [[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(apiFuncTicket:didFinishWithData:)didFailSelector:@selector(apiFuncTicket:didFailWithError:)] autorelease];
	[fetcher start];
	[consumer release];
	[request release];
}


- (void)apiFuncTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    NSLog(@"finish well");
    NSURL* url = [[[NSURL alloc] initWithString:[[ticket request] signURL]] autorelease];
    if ([delegate respondsToSelector:@selector(didServerOperationSuccess:andURL:)])
    {
        [delegate didServerOperationSuccess:data andURL:url];
    }
    
}
- (void)apiFuncTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
    NSLog(@"jot to the mang ");
}

- (void)loadImageURL:(NSString*)url
{
    NSData* imageData;

    NSString *fullURL = [NSString stringWithFormat:@"%@%@", _serverUrl , url];

    imageData = [[ImageCacheManager instance] getImageFromCache:fullURL];
    // if cache hits use that 
    if ( imageData != nil )
    {
        NSLog(@"cache hits");
        NSURL *nsurl = [[NSURL alloc] initWithString:url];
        [delegate didServerOperationSuccess:imageData andURL:nsurl];
        [nsurl release];
    }
    else 
    {
        NSLog(@"cache misses");
        // if cache not hit invoke sendRequestURL
        [self sendRequestURL:url andParams:nil];
    }
}


-(void)sendPostRequest:(NSString*)url andParams:(NSMutableDictionary*)params
{
    [self checkReachability];
    NSURL* nsurl = [[NSURL alloc] initWithString:url];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:nsurl];
    [request setStringEncoding:EUC_KR];
    for ( NSString* key in params)
    {
        NSRange paygatekey = [paygateRequestKeys rangeOfString:key];
        if ( paygatekey.location != NSNotFound ) {
            NSString* value = [params objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    NSLog(@"postreq is - %@%@", url, [TextUtil createParamString:params]);
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
    [nsurl release];
}


- (NSData*)sendSyncRequestURL:(NSString*)url andParams:(NSMutableDictionary*)params
{
    url = [NSString stringWithFormat:@"%@%@", _serverUrl, url];
    NSURL* nsurl = [TextUtil createURL:url withParamDic:params];
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:nsurl] autorelease];
    [request startSynchronous]; 
    return [request responseData];
}



- (void)sendRequestURL:(NSString*)url andParams:(NSMutableDictionary*)params
{
    [self checkReachability];
    url = [NSString stringWithFormat:@"%@%@", _serverUrl , url];
    NSURL* nsurl = [TextUtil createURL:url withParamDic:params];
    NSLog(@"nsurl string is %@", [nsurl absoluteString]);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:nsurl] ;
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSLog(@"requestDone");
    NSData *responseData = [request responseData];
    NSURL* url = [request url];
    if ([delegate respondsToSelector:@selector(didServerOperationSuccess:andURL:)])
    {
        [delegate didServerOperationSuccess:responseData andURL:url];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"requestWentWrong : %@", [error description]);
    if ([delegate respondsToSelector:@selector(didServerOperationFail:andErrorMsg:)])
    {
        [delegate didServerOperationFail:[request url] andErrorMsg:[error localizedDescription]];
    }
}

#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ;
}

- (void)dealloc
{
    NSLog(@"dealloc serverhelper");
    [super dealloc];
}
@end
