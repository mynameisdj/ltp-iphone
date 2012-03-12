//
//  AreaManager.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Area;


@interface AreaManager : NSObject {
    NSMutableArray* areaList;
    NSString* currentAreaName;
}

@property (nonatomic, retain) NSMutableArray *areaList;
@property (nonatomic, copy) NSString* currentAreaName;

+ (id)instance;
- (int)currentAreaCode;
- (Area *)getCurrentArea;
- (int)getAreaCode:(NSString*)areaName;
- (NSString*)getAreaName:(int)areaCode;
- (void) setAreaCodeWithLng:(double)lng andLat:(double)lat;
- (double) getDistanceLng1:(double)lng1 Lat1:(double)lat1 Lng2:(double)lng2 Lat2:(double)lat2;
- (void)appendAreas:(NSArray*)areas;

@end
