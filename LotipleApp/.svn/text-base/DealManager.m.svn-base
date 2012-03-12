//
//  DealManager.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import "DealManager.h"
#import "DealItem.h"
#import "ServerConnection.h"
#import "ServerHelper.h"
#import "ServerUrls.h"
#import "LotipleAppAppDelegate.h"
#import "LTPConstant.h"
#import "JSONKit.h"
#import "AreaManager.h"

@implementation DealManager
@synthesize moreCells;
@synthesize dealList, dealMap, delegate, mapDelegate;


DealManager* _dealManager;

+ (id)instance
{   
    @synchronized (self) {
        if (!_dealManager)
        {
            _dealManager = [[DealManager alloc] init];		
        }
        
    }	
	return _dealManager;
}
-(void)dealloc
{
    [dealList release];
    [dealMap release];
    [serverHelper release];
    [super dealloc];
}

- (id)init
{
	self = [super init];
	if (self)
	{
		dealList = [[NSMutableArray alloc] init];
        dealMap = [[NSMutableArray alloc] init];
        serverHelper = [[ServerHelper alloc] initWithDelegate:self];
	}
	return self;
}

- (void)setDistance
{
    for (DealItem* adeal in dealList) 
    {
        adeal.distance = [[ServerConnection instance] getDistance:adeal];
    }
}

- (void)appendMoreDealsToList:(NSArray*)dealListFromServer
{
    int count = [dealListFromServer count];
    moreCells = NO;
    if ( count % 10 == 0 ) 
        moreCells = YES;
    if ( count == 0 )
        moreCells = NO;
    
    for ( int i = 0 ; i < count ; i++)
    {
        id deal = [dealListFromServer objectAtIndex:i];
        DealItem* newDeal = [[DealItem alloc] initWithJSON:deal];
        [dealList addObject:newDeal];
        [newDeal release];
    }
    
}

- (void)appendDealsToList:(NSArray*)dealListFromServer
{
    [dealList removeAllObjects]; // TODO: caching 을 해야하나?
    [self appendMoreDealsToList:dealListFromServer];
}

- (void)appendDealsToMap:(NSArray*)dealListFromServer
{
    [dealMap removeAllObjects];
    int count = [dealListFromServer count];
    for ( int i = 0 ; i < count ; i++)
    {
        id deal = [dealListFromServer objectAtIndex:i];
        DealItem* newDeal = [[DealItem alloc] initWithJSON:deal];
        [dealMap addObject:newDeal];
        [newDeal release];
    }
}

- (void)appendSingleDealToMap:(DealItem*)_deal
{
    [dealMap removeAllObjects];
    [_deal retain];
    [dealMap addObject:_deal];
}

# pragma mark - To Server 
- (void)server_getAllDealList
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setObject:@"all" forKey:@"type"];
    NSString* url = @DEAL_LIST_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
    [params release];
}

- (void)server_getDealListWithPage:(int)page_index
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setObject:int2str(page_index) forKey:@"page"];
    [params setObject:int2str([[AreaManager instance] currentAreaCode]) forKey:@"area"];
    NSString* url = @DEAL_LIST_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
    [params release];

}
- (void)server_refreshMap:(MKCoordinateRegion)region
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    
    float fx1 = region.center.longitude - region.span.longitudeDelta;
	float fx2 = region.center.longitude + region.span.longitudeDelta;
	float fy1 = region.center.latitude - region.span.latitudeDelta;
	float fy2 = region.center.latitude + region.span.latitudeDelta;
	
	int x1 = (int)(fx1 * 1000000.0f);
	int x2 = (int)(fx2 * 1000000.0f);
	int y1 = (int)(fy1 * 1000000.0f);
	int y2 = (int)(fy2 * 1000000.0f);
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:4];
    [params setObject:int2str(x1) forKey:@"x1"]; 
    [params setObject:int2str(x2) forKey:@"x2"]; 
    [params setObject:int2str(y1) forKey:@"y1"];
    [params setObject:int2str(y2) forKey:@"y2"];
    NSString* url = @DEAL_MAP_REGION_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
    [params release];
}


#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSDictionary *response_data = [response_all objectForKey:@"data"];
    NSArray *deal_list = [response_data objectForKey:@"deal_list"];
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];

    if ( [[chunks objectAtIndex:0] rangeOfString:@DEAL_MAP_REGION_REQUEST].location != NSNotFound )
    {
        [[DealManager instance ] appendDealsToMap:deal_list];
        if ([mapDelegate respondsToSelector:@selector(didDataUpdateSuccess)])
        {
            [mapDelegate didDataUpdateSuccess];
        }
    }
    else // Deal List 관련 리퀘스트 처리
    {
        int page_index = [self getPageIndexFromURL:[chunks objectAtIndex:1] ];
        if ( page_index > 1 )
            [self appendMoreDealsToList:deal_list];
        else
            [self appendDealsToList:deal_list];                
        if ([delegate respondsToSelector:@selector(didDataUpdateSuccess)])
        {
            [delegate didDataUpdateSuccess];
        }

    }
        [LotipleAppAppDelegate showBusyIndicator:NO];

}
- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"Server Op fail in DealManager");
    if ([delegate respondsToSelector:@selector(didDataUpdateFail:)])
    {
        [delegate didDataUpdateFail:errMsg];
    }
}

#pragma mark - private function 

-(int)getPageIndexFromURL:(NSString*)chunk
{
    int page_index = 1; 
    NSScanner *scanner = [NSScanner scannerWithString:chunk];
    if ([scanner scanString:@"page=" intoString:NULL]) 
    {
        [scanner scanInt:&page_index];
    }
    return page_index;
}


@end
