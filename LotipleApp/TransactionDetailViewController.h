//
//  TransactionDetailViewController.h
//  LotipleApp
//
//  Created by lotiple on 11. 5. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealItem.h"
@class Tran;

@interface TransactionDetailViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate> {
    
	IBOutlet UILabel* remainTimeLb;
	IBOutlet UILabel* remainLb;
	IBOutlet UILabel* countLb;
    IBOutlet UILabel* storenameLb;
    IBOutlet UILabel* addressLb;
    IBOutlet UILabel* address2Lb;
    IBOutlet UILabel* couponStringLb;
    IBOutlet UILabel* statusLb;
    IBOutlet UILabel* purchaseTimeLb;
    IBOutlet UILabel* phoneLb;
    IBOutlet UILabel* totalPriceLb;
    IBOutlet UIButton* mapBtn;
    IBOutlet UIButton* callBtn;
    IBOutlet UILabel* dealtitleLb;
    Tran* tran;
}

- (IBAction)buttonClicked:(id)sender;
- (id)initWithTran:(Tran*)_tran;
- (void)setTranUI;
- (NSString* ) getPurchaseTimeString:(NSDate*)purchase_time;

@end
