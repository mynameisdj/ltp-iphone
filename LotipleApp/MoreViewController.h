
//
//  MoreViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 13..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreViewController : UIViewController <UITableViewDelegate, UIAlertViewDelegate,UITableViewDataSource>
{
	IBOutlet UITableView* menuTv;
    NSString* title;
}



@end
