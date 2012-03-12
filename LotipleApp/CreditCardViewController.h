//
//  CreditCardViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate,
														UIPickerViewDelegate, UIPickerViewDataSource>
{
	IBOutlet UIButton* cardCb;

	IBOutlet UITextField* num1Tf;
	IBOutlet UITextField* num2Tf;
	IBOutlet UITextField* num3Tf;
	IBOutlet UITextField* num4Tf;
	IBOutlet UITextField* monthTf;
	IBOutlet UITextField* yearTf;
	
	IBOutlet UIButton* resetBtn;
	IBOutlet UIButton* acceptBtn;
	
	// 버튼 달린 피커뷰 - 귀찮아 리팩토링 안해...
	IBOutlet UIActionSheet* pickerAs;
	IBOutlet UIView* mypickerView;
	IBOutlet UIBarButtonItem* pickerCancelBtn;
	IBOutlet UIBarButtonItem* pickerAcceptBtn;
	IBOutlet UIPickerView* pickerPickerView;
	int selectedRow;
}

- (void)showPicker;

- (IBAction)editingChanged:(id)sender;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)pickerButtonClicked:(id)sender;


@end
