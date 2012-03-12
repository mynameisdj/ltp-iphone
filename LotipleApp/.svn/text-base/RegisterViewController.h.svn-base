//
//  RegisterViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 5. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTPUITextField.h"
#import "ServerHelper.h"
#import "ConfirmInputViewController.h"
#import "DataManagerDelegate.h"

typedef enum {
	PickerTypeGender,
    PickerTypeBirthYear,
    PickerTypeCarrier
} PickerType;


@interface RegisterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, DataManagerDelegate,

    
ConfirmInputDelegate, UIScrollViewDelegate, ServerOperationDelegate>
{
    IBOutlet UIScrollView* innerView;
	IBOutlet UITextField* emailTf;
	IBOutlet UITextField* nameTf;
	IBOutlet UITextField* pwTf;
	IBOutlet UITextField* pw2Tf;
    
    IBOutlet UITextField* phone2Tf;
    IBOutlet UITextField* phone3Tf;

	
	IBOutlet UIButton* submitBtn;
    IBOutlet UIButton* viewTermsBtn;
    IBOutlet UIButton* viewTermsBtn2;
    IBOutlet UIButton* viewTermsBtn3;
    
    IBOutlet UIButton* confirmPhoneBtn;    
    
    IBOutlet UIButton* carrierBtn;
    
    IBOutlet UIButton* genderBtn;
    IBOutlet UIButton* birthYearBtn;
    
    // 버튼 달린 피커뷰
	IBOutlet UIActionSheet* pickerAs;
	IBOutlet UIView* mypickerView;
	IBOutlet UIBarButtonItem* pickerCancelBtn;
	IBOutlet UIBarButtonItem* pickerAcceptBtn;
	IBOutlet UIPickerView* pickerPickerView;
    PickerType pickerType;
    NSArray* genderElements;
    NSMutableArray* birthYearElements;
    NSArray* carrierElements;
    int selectedRow;
    int selectedBirthYear;
    int selectedGender;
    
    NSString* confirmMobile;
    BOOL isphoneNumConfirmed;
    ServerHelper *serverHelper;
}
- (void)initPickerElement;
- (void)tryRegister;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)viewTerms:(int)term_type;
- (IBAction)viewPhoneConfirm;
- (IBAction)beginEdit:(UITextField*)sender;
- (void)showPicker:(PickerType)type;
@property (nonatomic, retain) IBOutlet UILabel* friendNameLb;
@property (nonatomic, retain) IBOutlet UILabel* friendDescLb;
@property (nonatomic, retain) UISwitch *okSw;
@property (nonatomic ) PickerType pickerType;
@property (nonatomic, assign ) int selectedRow , selectedBirthYear, selectedGender;


@end
