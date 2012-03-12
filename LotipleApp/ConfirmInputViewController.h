//
//  ConfirmInputViewController.h
//  LotipleApp
//
//  Created by 최치선 on 11. 6. 19..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerHelper.h"

@protocol ConfirmInputDelegate;
@interface ConfirmInputViewController : UIViewController <UIAlertViewDelegate>
{
    id delegate;
    
    IBOutlet UITextField* confirmNumberTf;
    IBOutlet UIButton* confirmBtn;
    IBOutlet UIBarButtonItem* cancelBtn;
    IBOutlet UILabel* inputAuthNumLb;
    ServerHelper *serverHelper;    
    NSString* mobile;
}

- (IBAction)buttonClicked:(id)sender;

@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, assign) id <ConfirmInputDelegate> delegate;

@end

@protocol ConfirmInputDelegate

- (void)successConfirm:(NSString*)friendName;
- (void)cancelConfirm;

@end
