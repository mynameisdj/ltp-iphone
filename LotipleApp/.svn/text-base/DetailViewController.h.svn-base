//
//  DetailViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 17..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"
#import "ServerOperationDelegate.h"
#import "ServerHelper.h"
#import "DealImageDelegate.h"
#import "PageControl.h"
#import "CommentTableViewController.h"
#import "AdultCheckDelegate.h"

@class DealItem;
@class Store;
@interface DetailViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate,
                                    ServerOperationDelegate, DealImageDelegate,PageControlDelegate, AdultCheckDelegate>
{
	IBOutlet UIScrollView* innerView;
    IBOutlet UITableView* commentTv;
	
    
    IBOutlet UIImageView* thumbnailIv;
	IBOutlet UILabel* remainTimeLb;
	IBOutlet UILabel* priceLb;
	IBOutlet UILabel* rpriceLb;
	IBOutlet UILabel* distanceLb;
	IBOutlet UIButton* likeBtn;
	IBOutlet UILabel* descLb, *descLbBackground;
    IBOutlet UILabel* storenameLb;
    IBOutlet UILabel* countLb;
    IBOutlet UILabel* discountLB;
    IBOutlet UILabel *dealNameLb;
    
    // 상점 정보
    IBOutlet UIImageView* storeHeadingIv;
    IBOutlet UILabel* addressLb;
    IBOutlet UILabel* address2Lb;
    IBOutlet UILabel* phoneNumberLb;
    IBOutlet UILabel* upjongLb;
    IBOutlet UILabel* workingHourLb;
    
    // 상점 정보 설명
    IBOutlet UIImageView *storeInfoBackground, *storeInfoBackgroundFooter;
    IBOutlet UILabel* upjongIntroLb;
    IBOutlet UILabel* heading1Lb;
    IBOutlet UIView* lineV;
    IBOutlet UILabel* sanghoLb;
    IBOutlet UIView* line2;
    IBOutlet UILabel* routeLb;
    IBOutlet UIButton* callBtn;
    
	IBOutlet UIButton* buyBtn;
	IBOutlet UIButton* mapBtn;
	
	IBOutlet UIScrollView* imagesSv;
	IBOutlet UIPageControl* imagesPc;
    
    IBOutlet UIView* whiteLine;
    IBOutlet UIImageView *commentTop;
    IBOutlet UILabel* lineCommentLb;
    IBOutlet UIButton* writeBtn;

	DealItem* deal;
    Store* store;
    BOOL pageControlIsChangingPage;
    float deltaY;
    NSString* phoneNum;
    
    NSOperationQueue* queue;
    
    // 코멘트가 변경되었는지 여부
    BOOL commentDirty;
    
    // async helper 변수
    ServerHelper *serverHelper;
    
    PageControl *pageControl;
    
    IBOutlet CommentTableViewController *commentTableViewController;
}

@property (nonatomic, retain) DealItem *deal;
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) IBOutlet UILabel* titleLb;
@property (nonatomic, retain) IBOutlet UILabel* storenameLb;
@property (nonatomic, retain) IBOutlet UIView *purchaseFloatingView;
@property (nonatomic, assign) float deltaY, commentTableHeightDelta;
@property (nonatomic, retain) NSString* phoneNum;

- (id)initWithDeal:(DealItem *)_deal;
- (void)setDealInfo;
- (void)setStoreUI;
- (IBAction)pageChanged:(id)sender;
- (IBAction)buttonClicked:(id)sender;


- (void) setInnerViewSizeByComment;

@end
