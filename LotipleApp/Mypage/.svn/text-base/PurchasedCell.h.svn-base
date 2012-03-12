//
//  PurchasedCell.h
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 3..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealImageDelegate.h"

@class Tran;

@interface PurchasedCell : UITableViewCell <DealImageDelegate> 
{
    IBOutlet UILabel* remainTimeLb;
	IBOutlet UILabel* subtitleLb;
	IBOutlet UILabel* storeNameLb;
	IBOutlet UILabel* couponNameLb;
    IBOutlet UIImageView *thumbnailIv;
  	Tran* tran;
}

@property (nonatomic, retain) UIImage *thumbnail;

- (void)setTran:(Tran*)tran;
- (void)loadImage;
- (void) setTranCellThumbnail: (UIImage * ) image;
@end
