//
//  AdultCheckViewController.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 9. 7..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerHelper.h"
#import "AdultCheckDelegate.h"

@interface AdultCheckViewController : UIViewController {
    ServerHelper* serverHelper;     
    IBOutlet UIButton* okBtn;
    IBOutlet UIButton* cancelBtn;
    IBOutlet UITextField* nameTf;
    IBOutlet UITextField* ssn1Tf;
    IBOutlet UITextField* ssn2Tf;
    NSObject<AdultCheckDelegate> *delegate;
}

@property (nonatomic, retain) NSObject<AdultCheckDelegate> *delegate;


@end
