//
//  Area.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 19..
//  Copyright 2011 Home. All rights reserved.
//

#import "Area.h"


@implementation Area
@synthesize code,lng,lat,name;

+ (id) initWithJSON:(NSDictionary *)json
{
    id newArea =[[[Area alloc] initWithJSON:json] autorelease];;
    return newArea;
}

- (id) initWithJSON:(NSDictionary*)json 
{
    self.code = [[json objectForKey:@"code"] intValue];
    self.name = [json objectForKey:@"name"];
    self.lng = [[json objectForKey:@"x"] doubleValue];
    self.lat = [[json objectForKey:@"y"] doubleValue];
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


@end
