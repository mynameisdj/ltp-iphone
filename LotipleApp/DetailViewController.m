//
//  DetailViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 17..
//  Copyright 2011 Home. All rights reserved.
//

#import "DetailViewController.h"
#import "PurchaseViewController.h"
#import "WriteCommentViewController.h"
#import "ServerConnection.h"
#import "AdultCheckViewController.h"

#import "LotipleAppAppDelegate.h"
#import "LoginViewController.h"

#import "DealItem.h"
#import "Store.h"
#import "Comment.h"
#import "TextUtil.h"
#import "CommentCell.h"
#import "ReplyCell.h"
#import "ServerUrls.h"
#import "Util.h"
#import "ServerHelper.h"
#import "LTPConstant.h"
#import "JSONKit.h"
#import "AdultCheckDelegate.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 222.0f
#define CELL_CONTENT_MARGIN 8.0f

@implementation DetailViewController

@synthesize titleLb, storenameLb;

@synthesize store, deal;
@synthesize deltaY, commentTableHeightDelta;
@synthesize phoneNum;
@synthesize purchaseFloatingView;

static NSString* PhoneCall = @"전화걸기";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

// TODO : refactoring
- (id)initWithDeal:(DealItem *)_deal
{
    self = [super init];
    if (self)
    {
        self.deal = _deal;
        [_deal retain];
    }
    return self;
}

- (void)dealloc
{
    [buyBtn release];    
    [mapBtn release];  
    [deal release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Server Operation
- (void)server_getStoreInfo:(int)store_id
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:int2str(store_id) forKey:@"store_id"]; 
    NSString* url = @STORE_DETAIL_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
    [params release];
}

- (void)server_getStoreCommentList:(int)store_id
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:int2str(store_id) forKey:@"store_id"]; 
    NSString* url = @COMMENT_LIST_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
    [params release];
}

- (void)server_registerLike:(int)store_id
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:int2str(store_id) forKey:@"store_id"]; 
    NSString* url = @STORE_LIKE_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
    [params release];
}

- (void)server_buyCheck
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithCapacity:2];
    int deal_id = self.deal._id;
    [params setObject:int2str(deal_id) forKey:@"deal_id"]; 
    NSString* url = @DEAL_BUY_CHECK_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
    [params release];
}

- (void)pageControlPageDidChange:(PageControl *)_pageControl {
    CGRect frame = imagesSv.frame;
	frame.origin.x = frame.size.width * _pageControl.currentPage;
	frame.origin.y = 0;
    
	[imagesSv scrollRectToVisible:frame animated:YES];
    
	pageControlIsChangingPage = YES;
}

#pragma mark - View lifecycle


- (void) initPageControl {
    CGRect f = CGRectMake(0,230, 320, 20); 
    pageControl = [[PageControl alloc] initWithFrame:f];
    pageControl.numberOfPages = 1;
    pageControl.currentPage = 0;
    pageControl.delegate = self;
    [innerView addSubview:pageControl];
}



- (void)viewDidLoad
{
    NSLog(@"%s:%s",__FILE__,__FUNCTION__);
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.	
    serverHelper = [[ServerHelper alloc] initWithDelegate:self];
	
	// scroll view
	[self.view addSubview:innerView];

	[innerView setContentSize:innerView.frame.size];
	[innerView setFrame:[self.view frame]];
        
    commentDirty = YES;
    commentTv.separatorColor = [UIColor blackColor];
    
    [self initPageControl];

    [self setDealInfo];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"AppleGothic" size: 20.0];
    [label setMinimumFontSize:5.0];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"상세정보"];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
    [label release];
    
    dealNameLb.text = [TextUtil stringByDecodingXMLEntities:deal.title];

}

- (void) showPurchaseView {
    [((LotipleAppAppDelegate*)[[UIApplication sharedApplication] delegate]).window addSubview:purchaseFloatingView];
    purchaseFloatingView.frame = CGRectMake(0, 429, 320, 51);
}

- (void) hidePurchaseView {
    [purchaseFloatingView removeFromSuperview];
}

- (void)keyboardDidShow:(id)sender {
    [innerView setFrame:CGRectMake(0 ,0, 320, 200)];
}

- (void)keyboardWillhide:(id)sender {
    [innerView setFrame:CGRectMake(0 ,0, 320, 367)];
}

- (void)scrollToTextView:(NSNotification *)noti{
    float ry = [[[noti userInfo] objectForKey:@"y"] floatValue];
    [innerView setContentOffset:CGPointMake(0, ry) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInnerViewSizeByComment) name:@"CommentTableHeightChanged" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTextView:) name:@"ReplyEditingStarted" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCommentList) name:@"CommentListUpdated" object:nil];

    
    [self showPurchaseView];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) hideTabbar];
    
    if (self.deal && commentDirty )
	{
        commentDirty = NO;
        // TODO : comment 새로 썼을때 comment list 가 refresh되어야 함.
        [self server_getStoreInfo:self.deal.store_id];
        [self server_getStoreCommentList:self.deal.store_id];
        // 현재 이게 들어가면 이상하게 나옴
    }
       NSLog(@"%s %@",__FUNCTION__, [NSString stringWithFormat:@"/deal/%d/%d", deal.area_code, deal._id ]);
    
    [LotipleUtil trackPV:[NSString stringWithFormat:@"/deal/%d/%d", deal.area_code, deal._id ]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self hidePurchaseView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [queue cancelAllOperations];    
}

- (void)viewDidUnload
{
    [pageControl release];
    [queue cancelAllOperations];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)setDetailImages
{
	CGFloat cx = 0;
	NSArray* imagesDt = [deal getDetailImages];
    NSMutableArray *images = [NSMutableArray arrayWithArray:imagesDt];
	for (UIImage* image in images)
	{
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		CGSize imageSize = image.size;
		imageSize.width = MIN(302, imageSize.width);
		
		CGRect rect = imageView.frame;
		rect.size.height = imageSize.height;
		rect.size.width = imageSize.width;
		rect.origin.x = ((imagesSv.frame.size.width - imageSize.width) / 2) + cx;
		rect.origin.y = ((imagesSv.frame.size.height - imageSize.height) / 2);
		
		imageView.frame = rect;
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		
		
		[imagesSv addSubview:imageView];
		[imageView release];
		
		cx += imagesSv.frame.size.width;
		
	}
	imagesPc.numberOfPages = [images count];
    pageControl.numberOfPages = [images count];
    pageControl.currentPage = 0;

	[imagesSv setContentSize:CGSizeMake(cx, [imagesSv bounds].size.height)];
}

- (void)setStoreUI
{
    if ( store == nil ) 
        return ;
    NSLog(@"%s %@",__FUNCTION__, store.store_name);
    sanghoLb.text = [TextUtil stringByDecodingXMLEntities:store.store_name] ;
    addressLb.text = [TextUtil stringByDecodingXMLEntities:store.store_address];
    address2Lb.text = [TextUtil stringByDecodingXMLEntities:store.store_address2];
    phoneNumberLb.text = store.phone;
    upjongLb.text = store.upjong;
    workingHourLb.text = store.working_hour;
    storenameLb.text = [TextUtil stringByDecodingXMLEntities:store.store_name];
    routeLb.text = [TextUtil stringByDecodingXMLEntities:store.route_desc];
    
    
    self.phoneNum = store.phone;
    
    // dynamic 하게 view 의 위치 변경
    NSLog(@"%s %f", __FUNCTION__, deltaY);
    [Util repositionView:storeHeadingIv andDeltaY:deltaY];
    [Util repositionView:addressLb andDeltaY:deltaY];
    [Util repositionView:upjongLb andDeltaY:deltaY];
    [Util repositionView:workingHourLb andDeltaY:deltaY];
    [Util repositionView:upjongIntroLb andDeltaY:deltaY];
    [Util repositionView:heading1Lb andDeltaY:deltaY];
    [Util repositionView:lineV andDeltaY:deltaY];
    [Util repositionView:sanghoLb andDeltaY:deltaY];
    [Util repositionView:line2 andDeltaY:deltaY];
    [Util repositionView:address2Lb andDeltaY:deltaY];
    [Util repositionView:routeLb andDeltaY:deltaY];
    [Util repositionView:phoneNumberLb andDeltaY:deltaY];
    [Util repositionView:callBtn andDeltaY:deltaY];
    
    [Util repositionView:storeInfoBackground andDeltaY:deltaY];
    [Util repositionView:mapBtn andDeltaY:deltaY];
    [Util repositionView:storeInfoBackgroundFooter andDeltaY:deltaY];    
    
    float baseHeight = routeLb.frame.size.height;
    
    [routeLb sizeToFit];
    deltaY += routeLb.frame.size.height - baseHeight;
    NSLog(@"now height is %f baseHeight is %f", routeLb.frame.size.height , baseHeight );
    [Util resizeView:storeInfoBackgroundFooter width:0 height:MAX(routeLb.frame.size.height - baseHeight,3.0f)];
    UIImage *sImage = [storeInfoBackgroundFooter.image stretchableImageWithLeftCapWidth:0 topCapHeight:5];
    storeInfoBackgroundFooter.image = sImage;

    // comment section
    [Util repositionView:commentTv andDeltaY:deltaY];

    //applied delta removed
    deltaY = 0;
    
    [self setInnerViewSizeByComment];
}	

- (void)setDealInfo
{
    DealItem *aDeal = self.deal;
	thumbnailIv.image = nil;
	
	remainTimeLb.text = [aDeal getTimePeriod];
    
	self.titleLb.text = aDeal.title;
	self.storenameLb.text = deal.store_name;
    NSLog(@"%s %@",__FUNCTION__ ,aDeal.title);
    
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
	priceLb.text = [[frmtr stringFromNumber:[NSNumber numberWithInt:aDeal.price]] stringByAppendingString:@"원"];
	rpriceLb.text = [[frmtr stringFromNumber:[NSNumber numberWithInt:aDeal.reduced_price]] stringByAppendingString:@"원"];
    [frmtr release];    
	
	float distance = deal.distance;
    distanceLb.text = [NSString stringWithFormat:@"%dkm", (int)(distance/1000.0f)];
    if (distance/1000.0f > 99.0f) {
        distanceLb.text = @"99km+";
    } else if ( distance / 1000.0f < 1.0f ) {
        distanceLb.text = [NSString stringWithFormat:@"%dm", (int)distance];
    }



    [likeBtn setTitle:[NSString stringWithFormat:@"%d", aDeal.like] forState:UIControlStateNormal];    
    
            
    discountLB.text = [NSString stringWithFormat:@"(%d%%   )", aDeal.discount_rate];
  
    NSString* desc = aDeal.description;
    descLb.text = [TextUtil stringByDecodingXMLEntities:desc];
	
	float baseHeight = descLb.frame.size.height;
    [descLb sizeToFit];
    //adding margin
    CGSize descSize = descLb.frame.size;
    descLb.frame = CGRectMake(descLb.frame.origin.x, descLb.frame.origin.y, 280, descSize.height+30);
    deltaY = descLb.frame.size.height - baseHeight;
    NSLog(@"%s %@ %f", __FUNCTION__, descLb, deltaY);
    CGRect descLbFrame = descLbBackground.frame;
    descLbBackground.frame = CGRectMake(descLbFrame.origin.x, descLbFrame.origin.y, 320, descSize.height+30);

	// images setup
	imagesSv.delegate = self;
	[imagesSv setCanCancelContentTouches:NO];
	
	imagesSv.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	imagesSv.clipsToBounds = YES;
	imagesSv.scrollEnabled = YES;
	imagesSv.pagingEnabled = YES;
    imagesPc.numberOfPages = 1;

	
	queue = [NSOperationQueue new];

	

    NSInvocationOperation *detailImageOperation = [[NSInvocationOperation alloc] 
										initWithTarget:self
										selector:@selector( asyncGetDetailImage )
										object:nil];
    
    NSInvocationOperation *dealdetailInfoOperation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector( asyncDealDetailInfo )
                                        object:nil];
    

    [queue addOperation:detailImageOperation];
    [queue addOperation:dealdetailInfoOperation];
    [dealdetailInfoOperation release];
	[detailImageOperation release];

}

- (void)asyncDealDetailInfo
{
    DealItem *aDeal = self.deal;
    int current_ordered_count = [[ServerConnection instance] getDealVariantInfo:aDeal._id];
    if ( current_ordered_count != -1 )
        aDeal.current_ordered_count = current_ordered_count;
	int remainCnt = aDeal.max_count - aDeal.current_ordered_count;
    if ( remainCnt != 0 )
        countLb.text = @"";
    else {
        countLb.text = @"매진";
        countLb.highlighted = YES;
    }
    
}


- (void)asyncGetDetailImage
{
    [deal getDetailImages];
	[self performSelectorOnMainThread:@selector(setDetailImages) withObject:nil waitUntilDone:NO];
}

#pragma mark - handleServerOp
-(void) handle_storeInfo:(NSData*)responseData
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSDictionary *storeDic = [response_all objectForKey:@"store"];
    store = [[Store alloc] initWithJSON:storeDic];
    [self setStoreUI];
}

- (void) setInnerViewSizeByComment {
    CGSize newInnerContentSize = innerView.contentSize;
    float commentTableHeightSum = [commentTableViewController getCommentTableHeightSum];

    newInnerContentSize.height = storeInfoBackgroundFooter.frame.origin.y + storeInfoBackgroundFooter.frame.size.height + commentTableHeightSum;
    commentTableViewController.view.frame = CGRectMake(0, newInnerContentSize.height - commentTableHeightSum, 320, commentTableHeightSum+80 );
    newInnerContentSize.height += 50;    
    [innerView setContentSize:newInnerContentSize ];

}

- (void)updateCommentList {
    [self server_getStoreCommentList:self.deal.store_id];
}

-(void) handle_commentList:(NSData*)responseData
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    [commentTableViewController setCommentListUI:response_all];
    [self setInnerViewSizeByComment];
    [commentTableViewController.tableView reloadData];
    // TODO: setCommentList 같은걸 만들수도 있지 않나? 
    // 보통 UI 함수도 다른 thread 로 빼는게 정석인가? 
}



-(void) handle_storeLike:(NSData*)responseData
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString *response_code = [response_all objectForKey:@"code"];
    if ( [@"OK" isEqualToString:response_code] )
    {
        [likeBtn setTitle:[NSString stringWithFormat:@"%d", deal.like + 1] forState:UIControlStateNormal]; 
    }
    else
    {
        NSString* response_msg = [response_all objectForKey:@"msg"];
        [Util showAlertView:nil message:response_msg];
    }
}
-(void)pushPurchaseViewController
{
    PurchaseViewController* purchaseView = [[PurchaseViewController alloc] init];
    [purchaseView setDeal:deal]; // TODO
    [self.navigationController pushViewController:purchaseView animated:YES];
    [purchaseView release];

}

-(void)handle_buyCheck:(NSData*)responseData 
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString *response_code = [response_all objectForKey:@"code"];
    NSString *response_msg = [response_all objectForKey:@"msg"];
    if ( [@"OK" isEqualToString:response_code] )
    {
        NSDictionary *response_data = [response_all objectForKey:@"data"];
        NSString* can_buy_mobile = [response_data objectForKey:@"can_buy_mobile"];
        // 매달 말일의 경우 - 핸드폰 결제가 이루어져서는 안된다 ㅠㅠ
        // 말일의 경우 false 로 날라옴. 나머지일은 true 
        if ( [@"false" isEqualToString:can_buy_mobile ]) 
        {
            [[ServerConnection instance] setPurchaseOptionCnt:2];
        }
        [self pushPurchaseViewController];
    }
    else if ( [@"NEED_LOGIN" isEqualToString:response_code] )
    {
        [Util showLoginView:self message:@"구매하시기 위해서는 로그인/회원가입이 필요합니다."];
    }
    else
    {
        NSLog(@"response_code is %@", response_code);
        [Util showAlertView:self message:response_msg];
        if ( [@"NEED_NAME_CHECK" isEqualToString:response_code]) 
        {
            AdultCheckViewController* aView = [[AdultCheckViewController alloc] init];
            [aView setDelegate:self];
            [aView setTitle:@ADULTCHECK];
            [LotipleUtil trackPV:@"/more/adultcheck"];
            [self presentModalViewController:aView animated:YES];
            [aView release];

        }
    }

}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@STORE_DETAIL_REQUEST].location != NSNotFound )
    {
        [self handle_storeInfo:responseData];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@COMMENT_LIST_REQUEST].location != NSNotFound )
    {
        [self handle_commentList:responseData];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@STORE_LIKE_REQUEST].location != NSNotFound )
    {
        [self handle_storeLike:responseData];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@DEAL_BUY_CHECK_REQUEST].location != NSNotFound )
    {
        [self handle_buyCheck:responseData];
    }
    [LotipleAppAppDelegate showBusyIndicator:NO];
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"ServerOperationFail");
    [LotipleAppAppDelegate showBusyIndicator:NO];
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
	if (pageControlIsChangingPage)
	{
		return;
	}
	
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	imagesPc.currentPage = page;
	pageControl.currentPage = page;
	[innerView scrollRectToVisible:imagesSv.frame animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
	pageControlIsChangingPage = NO;
}



#pragma mark - Event handlers

- (IBAction)pageChanged:(id)sender 
{
	CGRect frame = imagesSv.frame;
	frame.origin.x = frame.size.width * imagesPc.currentPage;
	frame.origin.y = 0;

	[imagesSv scrollRectToVisible:frame animated:YES];

	pageControlIsChangingPage = YES;
}


- (NSString*) getErrorString
{
    ServerConnection* servercon = [ServerConnection instance];
    if ( servercon.logged == false )
        return @"NEED_LOGIN";
    NSString* ret = [servercon getDealPurchaseAvailable:deal._id];
    if (![ret isEqualToString:@"OK"])
        return ret;
         
	    
    return @"OK";
}

- (IBAction)buttonClicked:(id)sender
{
	ServerConnection* servercon = [ServerConnection instance];
	
	if (sender == buyBtn)
	{
        if ( [[ServerConnection instance] logged] == NO )
        {
            [Util showLoginView:self message:@"구매하시기 위해서는 로그인이 필요합니다."];
            return ;
        }
        [self server_buyCheck];

    }
	else if (sender == mapBtn)
	{
        // check 기본 맵 어플로 넘길까요?
        // [self moveToMapApplication];
        NSString *latlngStr = [[NSString stringWithFormat:@"%@@%f,%f",deal.store_name, deal.lat, deal.lng ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?z=15&q=%@",latlngStr]]];
	}
	else if (sender == likeBtn)       
	{
		if (servercon.logged)
		{
            [self server_registerLike:deal.store_id];
		}
		else
		{
            [Util showLoginView:self message:@"구매하시기 위해서는 로그인/회원가입이 필요합니다."];
		}
	}
    else if (sender == callBtn)
    {
        if ( [phoneNumberLb.text isEqualToString:@"없음"] ) {
            [Util showAlertView:self message:@"전화번호가 없는 상점입니다."];
            return;
        }
        NSString* device = [[UIDevice currentDevice] model];   
        if ([device rangeOfString:@"iPhone"].location != NSNotFound ) {
            
            [Util showConfirmView:self andTitle:PhoneCall andMessage:@"상점으로 전화거시겠습니까?" ];
        }
        else
        {
            [Util showAlertView:self message:@"이 기기는 전화걸기 기능을 지원하지 않습니다."];
            return;
        }

    }
}


#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [alertView.title isEqualToString:PhoneCall] ) 
    {
        if ( buttonIndex == 1 ) 
        {
            // 전화걸기 OK 한 경우
            NSString* callStr = [NSString stringWithFormat:@"tel://%@", self.phoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
        }
    }
    else 
    {
        // 로그인 기능
        if (buttonIndex == 0)
        {
            NSLog(@"button index 0 ");
        }
        else if (buttonIndex == 1)
        {      
            LoginViewController* loginView =[[LoginViewController alloc ] init ]; 
            [[self navigationController] pushViewController:loginView animated:YES];
            [loginView release];
        }
        else
            NSLog(@"button rest ..");
    }
}

#pragma mark -
#pragma make below table IBAction

- (IBAction)writeButtonClicked: (id) sender {
    if ([[ ServerConnection instance] logged] ) {
        WriteCommentViewController *viewController = [[WriteCommentViewController alloc] init];
        viewController.deal_id = [deal _id];
        [self.navigationController pushViewController:viewController animated:YES];
        commentDirty = YES;
        [viewController release];
    }
    else{
        
        [Util showLoginView:self message:@"로그인이 필요합니다"];
    }
}

#pragma mark - DealImageDelegate
- (void)couldNotLoadImageError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didLoadImage:(UIImage *)image;
{
    thumbnailIv.image = image;
}

#pragma mark - AdultCheckDelegate
- (void)didAdultCheckSuccess
{
    [self server_buyCheck];
}

@end
