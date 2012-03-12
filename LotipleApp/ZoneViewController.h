//
//  ZoneViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 15..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZoneViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* areaArray;
    IBOutlet UITableView *areaTable;
}

@property (nonatomic, retain) NSMutableArray* areaArray;
@property (nonatomic, retain) IBOutlet UINavigationItem *customNavigationItem;

- (IBAction)buttonClicked:(id)sender;

@end
