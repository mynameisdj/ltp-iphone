//
//  MyTransactionViewController.h
//  LotipleApp
//
//  Created by lotiple on 11. 5. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchasedCell.h"
#import "ServerHelper.h"
#import "DataManagerDelegate.h"

@interface MyTransactionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DataManagerDelegate, UIScrollViewDelegate> {
    IBOutlet UITableView* itemsTv;
    
    
    NSMutableArray *transArray;
    NSMutableArray *unusedTransArray, *usedTransArray;
    
    UINib *PurchasedCellNib;
    IBOutlet PurchasedCell *purchasedCellProto;
    ServerHelper *serverHelper;
    
    IBOutlet UIButton *segmentedUnusedUIButton, *segmentedUsedUIButton;
    BOOL showingUnused;
}

@property (nonatomic, retain)  IBOutlet PurchasedCell *purchasedCellProto;
@property (nonatomic, retain) UINib *PurchasedCellNib;
@property (nonatomic, retain) NSMutableArray *transArray;


- (void)loadContentForVisibleCells;

@end
