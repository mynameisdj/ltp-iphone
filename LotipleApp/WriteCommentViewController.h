//
//  WriteCommentViewController.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerHelper.h"

@interface WriteCommentViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate > {
    IBOutlet UITextView *commentTextView;
    int deal_id;
    IBOutlet UILabel *textCountLb;
    ServerHelper *serverHelper;
}

@property (nonatomic, assign) int deal_id;


@end
