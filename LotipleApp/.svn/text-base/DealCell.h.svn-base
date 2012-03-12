//
//  DealCell.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 14..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import "DealImageDelegate.h"

@class DealItem;

@interface DealCell : UITableViewCell <CLLocationManagerDelegate, DealImageDelegate >
{
	IBOutlet UIImageView* thumbnailIv, *soldoutRibbonIv, *priceDownIv, *betweenPriceAndDiscount, *goLeftIv;
	IBOutlet UILabel* remainTimeLb;
	IBOutlet UILabel* titleLb;
	IBOutlet UILabel* storeNameLb;
	IBOutlet UILabel* priceLb;
	IBOutlet UILabel* rpriceLb;
	IBOutlet UILabel* distanceLb;
	IBOutlet UILabel* descLb;
    IBOutlet UILabel* remainCnt;
    IBOutlet UILabel* discountRateLb;
    
	DealItem* deal;
}

- (void)setDeal:(DealItem*)deal;
- (void)loadImage;
- (void) setDealCellThumbnail: (UIImage * ) image;
@end
