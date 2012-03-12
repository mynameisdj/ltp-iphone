	//
//  ListViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 13..
//  Copyright 2011 Home. All rights reserved.
//

#import "ListViewController.h"

#import "ZoneViewController.h"
#import "CategoryViewController.h"
#import "ServerConnection.h"
#import "DetailViewController.h"
#import "LotipleAppAppDelegate.h"
#import "JSONKit.h"
#import "ServerHelper.h"
#import "DealItem.h"
#import "DealCell.h"
#import "Store.h"
#import "TextUtil.h"
#import "Util.h"
#import "ServerUrls.h"
#import "LTPConstant.h"

#import "DealManager.h"
#import "AreaManager.h"
#import "UserManager.h"


@implementation ListViewController
@synthesize forceViewDealDetail=_forceViewDealDetail;

#define LABEL_MORE_CELLS "더 보기..."
static int errTry = 0;
BOOL firstTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        _forceViewDealDetail = 0;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [dealsFiltered release];
    [serverHelper release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s",__FUNCTION__);
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Server Operation

- (void)server_getServerInfo
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:@"2" forKey:@"route"]; // iphone
    [params setObject:[TextUtil getVerStr] forKey:@"ios_app_ver"]; 
    NSString* url = @SERVER_INFO_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
    [params release];
}

- (void)registerDeviceToken
{
    UserManager *um = [UserManager instance];
    if ( [[ServerConnection instance] logged] == YES )
    {
        [um registerDeviceToken];
    }
}


#pragma mark - View lifecycle

- (void) loadView {
    [super loadView];
    UIView *viewForLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 51, 24)];
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 51, 24)];
    [left setImage:[UIImage imageNamed:@"loSelect.png"] forState:UIControlStateNormal];
    [left setImage:[UIImage imageNamed:@"loSelect_touch.png"] forState:UIControlStateHighlighted];
    [left setShowsTouchWhenHighlighted:NO];
    [left addTarget:self action:@selector(selectZone:) forControlEvents:UIControlEventTouchUpInside];
    [viewForLeft addSubview:left];
    [left release];
    
    UIBarButtonItem* leftBtn;
    leftBtn = [[UIBarButtonItem alloc] initWithCustomView:viewForLeft];
    [viewForLeft release];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    firstTime = YES;
    currentPage = 1;
    serverHelper = [[ServerHelper alloc] initWithDelegate:self];
    [self server_getServerInfo];
    [self registerDeviceToken];
    [[DealManager instance] setDelegate:self];
    [[DealManager instance] server_getAllDealList];
    [[ServerConnection instance] setDelegate:self];
    
    dealsFiltered = [[NSMutableArray alloc]init ];
    // Do any additional setup after loading the view from its nib.
	
    // 로케이션매니저와 뷰콘트롤러 연결
    [[ServerConnection instance] addLocationListener:self]; // ???
    if (_refreshHeaderView == nil)
	{
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - dealsTv.bounds.size.height, self.view.frame.size.width, dealsTv.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[dealsTv addSubview:_refreshHeaderView];		
	}	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	// 지역선택 버튼
	
	// 카테고리 버튼...spec out
	if (0)
	{
		UIBarButtonItem* rightBtn;
		rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"카테고리"
													style:UIBarButtonItemStylePlain
												   target:self
												   action:@selector(buttonClicked:)];
		
		self.navigationItem.rightBarButtonItem = rightBtn;
		[rightBtn release];
	}
	dealsTv.separatorColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1];
    
    self.navigationItem.title = [[AreaManager instance] currentAreaName];
}

- (void)viewDidUnload
{
    [queue cancelAllOperations];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

	[_refreshHeaderView release];
	_refreshHeaderView = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    noResult = NO;
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) showTabbar];

    NSLog(@"%s",__FUNCTION__);    
    trackLater = NO;
    static NSString *lastAreaName = @"";
       self.navigationItem.title = [[AreaManager instance] currentAreaName];
    [self loadContentForVisibleCells];
    
    if ( (![lastAreaName isEqualToString:self.navigationItem.title]) && ( firstTime == NO) ) {
        NSLog(@"areaname changed");
        lastAreaName = self.navigationItem.title;
        [[DealManager instance] server_getDealListWithPage:1] ;
        currentPage = 1;
        [dealsTv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    if ([[AreaManager instance] currentAreaCode] != AREA_DONT_CARE) {
        [LotipleUtil trackPV:[NSString stringWithFormat:@"/deal_list/%d",[[AreaManager instance] currentAreaCode]]];
    }
    else {
        trackLater = YES;
    }
    firstTime = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s",__FUNCTION__);
    [super viewDidAppear:animated];
    
    if( _forceViewDealDetail )
    {
        [self showDealDetail:_forceViewDealDetail];
        _forceViewDealDetail = 0;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UI Event Handler

- (void) selectZone:(id)sender {
    ZoneViewController* controller = [[ZoneViewController alloc] init];
    [self presentModalViewController:controller animated:YES];	
    [controller release];
}

- (IBAction)buttonClicked:(id)sender
{
    if (sender == self.navigationItem.rightBarButtonItem)
	{
		CategoryViewController* controller = [[CategoryViewController alloc] init];
		[self presentModalViewController:controller animated:YES];	
        [controller release];
	}
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static CGFloat DealCellHeight = 0.0f;
	
	if (DealCellHeight == 0.0f)
	{
		// will be reused...
		NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"DealCells" owner:self options:nil];
		DealCell* cell = (DealCell*)[objects objectAtIndex:2];
		DealCellHeight = cell.frame.size.height;
	}
	
	if (indexPath.row < [dealsFiltered count])
	{
		return DealCellHeight;
	}
	
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < [dealsFiltered count])
	{
        DetailViewController* detailView = [[DetailViewController alloc] initWithDeal:[dealsFiltered objectAtIndex:indexPath.row]];
        detailView.hidesBottomBarWhenPushed =YES;
        [[self navigationController] pushViewController:detailView animated:YES];
		[detailView release];
	}
	else // view more cells 를 클릭했을때의 behavior
	{
        currentPage++;
        [[DealManager instance] server_getDealListWithPage:currentPage];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	const int MoreCellCount = 1;
	
	int cellCount = [dealsFiltered count];
	if ( [[DealManager instance] moreCells] == YES )
	{
		cellCount += MoreCellCount;
	}	
    if (cellCount == 0)
        return 1;
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [dealsFiltered count] && [dealsFiltered count] == 0 )
	{
		static NSString* CellIdentifier = @"CellIdentifier";
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor blackColor];
		}
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        cell.textLabel.text = (noResult) ? @"근처에 진행중이 딜이 없습니다." : @"딜을 로딩중입니다";
        
		return cell;
	}
    else if (indexPath.row == [dealsFiltered count] && [dealsFiltered count] > 0 ) 
    {
        static NSString* CellIdentifier = @"CellIdentifier";
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.textColor = [UIColor blackColor ];
            UIView *v = [[UIView alloc] init];
			v.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
			cell.selectedBackgroundView = v;
            [v release];

		}
        cell.textLabel.text = @LABEL_MORE_CELLS;
		return cell;
    }
    // 일반 셀
    else if (indexPath.row < [dealsFiltered count] )
	{
		DealCell* cell = nil;
		BOOL created = NO;
        
		NSLog(@"%s with index_row is %d",__FUNCTION__, indexPath.row);
        static NSString* CellIdentifier = @"DealCell2";
        cell = (DealCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"DealCells" owner:self options:nil];
            cell = (DealCell*)[objects objectAtIndex:2];
            created = YES;
        }
        
        if (created)
		{
			UIView *v = [[UIView alloc] init];
			v.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
			cell.selectedBackgroundView = v;
            [v release];
        }
        DealItem* deal = [dealsFiltered objectAtIndex:(indexPath.row)];
        NSLog(@"%@",deal.thumbnail);
        [cell setDeal:deal ];
        if ( indexPath.row < 4 ) { //viewWillAppear or 지역이 변경된경우 처음에 visible한 셀에만 loadImage를 적용.
            [cell loadImage];
        }
        
		return cell;
	}
    
	// crash
    return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{	
//	return [NSString stringWithFormat:@"Section %i", section];	
//}

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:dealsTv];
	
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];	
}


- (void)loadContentForVisibleCells
{
    NSArray *cells = [dealsTv visibleCells];
    [cells retain];
    for (int i = 0; i < [cells count]; i++) 
    { 
        // Go through each cell in the array and call its loadContent method if it responds to it.
        DealCell *dealCell = (DealCell *)[[cells objectAtIndex: i] retain];
        if ( [dealCell.textLabel.text isEqualToString:@LABEL_MORE_CELLS] == NO ) 
        {
            if ( [dealCell respondsToSelector:@selector(loadImage) ] ) 
            {
                [dealCell loadImage];
            }
            
        }
        [dealCell release];
        dealCell = nil;
        
    }
    [cells release];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView; 
{
    [self loadContentForVisibleCells]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (!decelerate) 
    {
        [self loadContentForVisibleCells]; 
    }
	
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    currentPage = 1;
    [[DealManager instance] server_getDealListWithPage:1] ;
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	
	return [NSDate date]; // should return date data source was last changed	
}

-(void)setAreaByLatLng
{
    float cur_lng = [[ServerConnection instance] cur_lng];
    float cur_lat = [[ServerConnection instance] cur_lat];
    [self setAreaByLatLng:cur_lat lng:cur_lng];
}

-(void)setAreaByLatLng:(float)lat lng:(float)lng
{
    myLng = lng*1000000;
    myLat = lat*1000000;
    [[AreaManager instance] setAreaCodeWithLng:lng  andLat:lat];
    NSString *currentAreaName = [[AreaManager instance] currentAreaName];
    NSLog(@"listview %s",__FUNCTION__);
    [[DealManager instance] setDistance];
    self.navigationItem.title = currentAreaName;
}

#pragma mark - CLLocationManagerDelegate
//위치가 변경되었을때 호출.
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"success %s",__FUNCTION__);
    CLLocationCoordinate2D location = [newLocation coordinate];
    [self setAreaByLatLng:location.latitude lng:location.longitude];
    
}

//위치를 못가져왔을때 에러 호출.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"fail while getting location %s",__FUNCTION__);
    [self setAreaByLatLng:37.498185 lng:127.027574];
}

#pragma mark - Filtering

-(void)updateAreaDealList
{
 
    NSLog(@"%s area updated'",__FUNCTION__);
    int area_code = [[AreaManager instance] currentAreaCode];
    NSLog(@"area_code is %d", area_code );
    [dealsFiltered removeAllObjects];
    noResult = ([[ [DealManager instance] dealList] count] == 0);
    for ( DealItem* deal in [ [DealManager instance] dealList] )
    {
        if ([deal area_code] == area_code) {
            [dealsFiltered addObject:deal];
        }
    }
    
    BOOL _moreCells = [[DealManager instance] moreCells];
    [[DealManager instance] setMoreCells:_moreCells];
    
    if (trackLater && [[AreaManager instance] currentAreaCode] != -1) {
        [LotipleUtil trackPV:[NSString stringWithFormat:@"/deal_list/%d",[[AreaManager instance] currentAreaCode]]];
        trackLater=NO;
    }
    [dealsTv reloadData];
}

#pragma mark - DataManagerDeleagate
- (void) didDataUpdateSuccess
{
    [self updateAreaDealList];
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [self loadContentForVisibleCells]; 
}
- (void) didDataUpdateFail:(NSString*)errorMsg
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    errTry++;
    if ( errTry < 3 ) 
    {
        [[DealManager instance] server_getAllDealList];

    }
    else 
    {
        errorMsg = [NSString stringWithFormat:@"에러메시지 : %@", errorMsg];
        [Util showAlertView:nil message:errorMsg];    
    }
}

#pragma mark - handlerForServerOp
-(void)handleServerInfo:(NSData*)responseData
{
    // data parsing
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSDictionary *response_data = [response_all objectForKey:@"data"];
    NSString* purchase_count_str = [response_data objectForKey:@"purchase_count"];
    NSString* latest_iphone_ver = [response_data objectForKey:@"latest_iphone_ver"];
    NSArray *area_list = [response_data objectForKey:@"area_list"];
    NSDictionary *user_info = [response_data objectForKey:@"user"];
    NSString *eventMode = [response_data objectForKey:@"friend_event"];

    NSTimeInterval timestamp = [[response_data objectForKey:@"last_event_update_time"] doubleValue] / 1000;
	NSDate* last_event_update_time = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    // latest_ver assign
    [[ServerConnection instance ] setNewIphoneAppVer:[latest_iphone_ver floatValue]];
    [[ServerConnection instance] showAlertIfAppisOutdate];
    
    // purchase_count assign
    [[ServerConnection instance] setPurchaseOptionCnt:[purchase_count_str intValue]];
    
    
    // 915 friend invitation event 
    if ( [@"true" isEqualToString:eventMode] == YES ) {
        [[ServerConnection instance] setEventMode:YES];
    }
    // last event board update time
    
    [[ServerConnection instance] setLastEventUpdateTime:last_event_update_time];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) onNotifyNoticeUpdatedTime:last_event_update_time];
    
    NSLog(@"last event update time is %@", last_event_update_time);
    // area info setting
    [[AreaManager instance] appendAreas:area_list];
    
    // user info setting
    [[UserManager instance] setDataWithDic:user_info];
    
    if ( [ [[AreaManager instance] currentAreaName] isEqualToString:@""] ) {
        [self setAreaByLatLng];
    }
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSLog(@"ServerOperationSuccess %@", [url absoluteString] );
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@SERVER_INFO_REQUEST].location != NSNotFound )
    {
        NSLog(@"ServerInfo");
        [self handleServerInfo:responseData];
    }
    [LotipleAppAppDelegate showBusyIndicator:NO];
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"ServerOperationFail");
    [LotipleAppAppDelegate showBusyIndicator:NO];
}


#pragma mark - push notification
// TODO - after dealItem / dealdetail refactoring
- (void)showDealDetail:(int)deal_id
{    
    NSLog(@"Show Deal Detail by push (%d)", deal_id);
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setObject:int2str(deal_id) forKey:@"deal_id"];
    NSData* response_nsdata = [serverHelper sendSyncRequestURL:@DEAL_LIST_REQUEST andParams:params];
    [params release];
    NSDictionary* response_all = [[JSONDecoder decoder] objectWithData:response_nsdata];
    if ( response_all == nil )
        goto NODEAL;
    NSDictionary* response_data = [response_all objectForKey:@"data"];
    if ( response_data == nil )
        goto NODEAL;

    NSArray* deals = [response_data objectForKey:@"deal_list"];
    if( [deals count] == 0 )
    {
        NODEAL:
        [Util showAlertView:nil message:@"아쉽게도 찾으시는 딜이 존재하지 않습니다만, 다른 딜을 구경해보는건 어떨까요?"];
        return;
    }
    
    [LotipleAppAppDelegate showBusyIndicator:YES];
    
    NSDictionary* dealInfo = [deals objectAtIndex:0];
    DealItem* _deal = [[DealItem alloc] initWithJSON:dealInfo];
    DetailViewController* detailView = [[DetailViewController alloc] initWithDeal:_deal];
    [_deal release];
    detailView.hidesBottomBarWhenPushed =YES;
    [[self navigationController] pushViewController:detailView animated:YES];
    [detailView release];
     
    
    [LotipleAppAppDelegate showBusyIndicator:NO];
}

@end
