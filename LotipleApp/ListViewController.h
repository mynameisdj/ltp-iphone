//
//  ListViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 13..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import <MapKit/MapKit.h>
#import "RefreshTableHeaderView/EGORefreshTableHeaderView.h"
#import "ServerOperationDelegate.h"
#import "ServerHelper.h"
#import "DataManagerDelegate.h"

@interface ListViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, ServerOperationDelegate, DataManagerDelegate>
{
    IBOutlet UITableView* dealsTv;

	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    BOOL noResult;
    int myLng;
    int myLat;

    NSMutableArray *dealsFiltered;
    
    int _forceViewDealDetail;
    
    BOOL trackLater;
    NSOperationQueue *queue;
    ServerHelper *serverHelper;
    int currentPage;
       
}


@property int forceViewDealDetail;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (IBAction)buttonClicked:(id)sender;
- (void)updateAreaDealList;
-(void)setAreaByLatLng:(float)lat lng:(float)lng;
- (void)showDealDetail:(int)deal_id;
- (void)loadContentForVisibleCells;

@end
