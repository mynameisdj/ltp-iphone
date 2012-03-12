//
//  Store.m
//  LotipleApp
//
//  Created by lotiple on 11. 5. 6..
//  Copyright 2011 Home. All rights reserved.
//

#import "Store.h"
#import "Comment.h"
#import "ServerConnection.h"
#import "JSONKit/JSONKit.h"

@implementation Store

@synthesize store_address, store_address2, store_name, x, y, working_hour, upjong, phone , imgPath, route_desc;

+ (id)storeWithJSON:(NSDictionary*)json
{
	id newStore = [[[Store alloc] initWithJSON:json] autorelease]; 
	return newStore;
}

- (id)initWithJSONDictionary: (NSDictionary*)jsonDic
{
    store_name = [jsonDic objectForKey:@"name"];
	store_address = [jsonDic objectForKey:@"addr1"];
    store_address2 = [jsonDic objectForKey:@"addr2"];
	x = [[jsonDic objectForKey:@"x"] intValue] / 1000000.0f;
	y = [[jsonDic objectForKey:@"y"] intValue] / 1000000.0f;
    working_hour = [jsonDic objectForKey:@"working_hour"];
    upjong = [jsonDic objectForKey:@"upjong"];
    phone = [jsonDic objectForKey:@"phone"];
    route_desc = [jsonDic objectForKey:@"route_description"];
    return self;
}


- (id)initWithJSONData : (NSData*)jsonData
{
    self = [super init];
    NSDictionary *items = [[JSONDecoder decoder] objectWithData:jsonData];
    return [self initWithJSONDictionary:items];
}

- (id)initWithJSON:(NSDictionary*)json
{
    self = [super init];
	store_name = [json objectForKey:@"name"];
	store_address = [json objectForKey:@"addr1"];
    store_address2 = [json objectForKey:@"addr2"];
	x = [[json objectForKey:@"x"] intValue] / 1000000.0f;
	y = [[json objectForKey:@"y"] intValue] / 1000000.0f;
    working_hour = [json objectForKey:@"working_hour"];
    upjong = [json objectForKey:@"upjong"];
    phone = [json objectForKey:@"phone"];
    route_desc = [json objectForKey:@"route_description"];
    /*
    if ( comment_list != nil ) 
    {
        int count = [comment_list count];
        commentList = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < count ; i++ )
        {
            id comment = [comment_list objectAtIndex:i];
            id newComment = [[Comment alloc ] initWithJSON:comment];
            [commentList addObject:newComment];
            [newComment release];
        }
    }*/
    return self;
}



- (UIImage*)getImage
{
	return [[ServerConnection instance] getStoreImg:imgPath];
}

- (void) dealloc {
    [super dealloc];
}


@end
