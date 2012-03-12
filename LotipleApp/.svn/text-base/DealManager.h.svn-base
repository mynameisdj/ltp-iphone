//
//  DealManager.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 2..
//  Copyright 2011 Home. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "DealItem.h"
#import "DataManagerDelegate.h"

@interface DealManager : NSObject <ServerOperationDelegate>
{
    BOOL moreCells;
    NSMutableArray* dealList;
    NSMutableArray* dealMap;
    ServerHelper* serverHelper;
    NSObject<DataManagerDelegate> *delegate;
    NSObject<DataManagerDelegate> *mapDelegate;
}

@property (nonatomic, assign) BOOL moreCells;
@property (nonatomic, retain) NSMutableArray *dealList, *dealMap;
@property (nonatomic, retain) NSObject<DataManagerDelegate> *delegate;
@property (nonatomic, retain) NSObject<DataManagerDelegate> *mapDelegate;

+ (id)instance;
- (void)setDistance;
- (void)appendMoreDealsToList:(NSArray*)dealListFromServer;
- (void)appendDealsToList:(NSArray*)dealListFromServer;
- (void)appendDealsToMap:(NSArray*)dealListFromServer;
- (void)appendSingleDealToMap:(DealItem*)_deal;
- (void)server_getAllDealList;
- (void)server_getDealListWithPage:(int)page_index;
- (int)getPageIndexFromURL:(NSString*)chunk;
- (void)server_refreshMap:(MKCoordinateRegion)region;

@end
