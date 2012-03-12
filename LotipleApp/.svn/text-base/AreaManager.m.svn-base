//
//  AreaManager.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import "AreaManager.h"
#import "Area.h"

@implementation AreaManager
@synthesize areaList, currentAreaName;
AreaManager* _areamanager;

+ (id)instance
{   
    @synchronized (self) {
        if (!_areamanager)
        {
            _areamanager = [[AreaManager alloc] init];		
        }
        
    }	
	return _areamanager;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        areaList = [[NSMutableArray alloc] init];
        [self setCurrentAreaName:@""];
    }
    return self;
}

- (void)dealloc
{
    [areaList release];
    [super dealloc];
}

- (int)currentAreaCode
{
    return [self getAreaCode:currentAreaName];
}

- (int)getAreaCode:(NSString*)areaName
{
    for  ( Area *area in areaList )
    {
        if ( [[area name] isEqualToString:areaName ] )
            return [area code];
    }
    return 1;
}

- (void) setAreaCodeWithLng:(double)lng andLat:(double)lat 
{
    if ( [[self currentAreaName] isEqualToString:@"" ] == NO )
        return ;
    double mindistance = 999999999999;
    NSString *minAreaName = @"";
    for ( Area *area in areaList )
    {
        double distance = [self getDistanceLng1:lng Lat1:lat Lng2:area.lng Lat2:area.lat ];
        if (distance < mindistance )
        {
            minAreaName = area.name; 
            mindistance = distance;
        }
    }
    [self setCurrentAreaName:minAreaName];
}

- (double) getDistanceLng1:(double)lng1 Lat1:(double)lat1 Lng2:(double)lng2 Lat2:(double)lat2  
{
    double dx, dy;
    dx = lng2 - lng1 ;
    dy = lat2 - lat1;
    return dx * dx + dy* dy;
}

- (NSString*)getAreaName:(int)areaCode
{
    for  ( Area *area in areaList )
    {
        if ( [area code] == areaCode  )
            return [area name];
    }
    return @"기타";
}

- (Area *)getCurrentArea 
{
    for  ( Area *area in areaList )
    {
        if ( [[area name] isEqualToString:currentAreaName ] )
            return area;
    }
    return nil;
}

- (void)appendAreas:(NSArray*)areas
{
    [areaList removeAllObjects];
    int count = [areas count];
    for (int i = 0 ; i < count ; i++ )
    {
        id area_id = [areas objectAtIndex:i];
        Area* newArea = [Area initWithJSON:area_id];
        NSLog(@"newArea %@", newArea.name );
        [areaList addObject:newArea];
    }
    
}





@end
