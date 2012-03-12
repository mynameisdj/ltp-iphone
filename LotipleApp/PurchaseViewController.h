//
//  PurchaseViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 19..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerHelper.h"
#import "LTPUITextField.h"
#import "ServerOperationDelegate.h"

@class DealItem;

typedef enum {
	PickerTypeCount,
    PickerTypePurchase,
    PickerTypeCard,
    PickerTypeCarrier
} PickerType;

@interface PurchaseViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, ServerOperationDelegate,
														UITextFieldDelegate, UIScrollViewDelegate,
														UIAlertViewDelegate>
{
    UITapGestureRecognizer *tap;
    
	IBOutlet UIScrollView* innerView;
	
	IBOutlet UILabel* titleLb;
	IBOutlet UIButton* countCb;	
	IBOutlet UILabel* priceLb;
    IBOutlet UILabel* pointLb;
    IBOutlet UILabel* noticeLb;
 
	
	IBOutlet UITextField* nameTf;
	IBOutlet UITextField* phoneTf;
    IBOutlet UITextField* emailTf;
    IBOutlet UIButton* purchaseCb;
		

	
    IBOutlet UIImageView* tabIv;
	
	// 버튼 달린 피커뷰 - 다른 창에서도 쓰여야 하면 리팩토링
	IBOutlet UIActionSheet* pickerAs;
	IBOutlet UIView* mypickerView;
	IBOutlet UIBarButtonItem* pickerCancelBtn;
	IBOutlet UIBarButtonItem* pickerAcceptBtn;
	IBOutlet UIPickerView* pickerPickerView;
	PickerType pickerType;
	int selectedRow;
    int selectedCount;
    NSArray* purchaseOption;
    int selectedPurchaseOption;
    NSArray* carrierName; // 통신사 이름
    NSString* transaction_id;

    NSLock *payLock;
	DealItem* deal;
    // 카드 정보
    IBOutlet UIView* cardInfoViewCol;
        IBOutlet UIView* cardInfoView;
        IBOutlet UILabel* cardNumberLb;
        IBOutlet UIButton* cardCb;
        IBOutlet UITextField* cardNum1Tf;
        IBOutlet UITextField* cardNum2Tf;
        IBOutlet UITextField* cardNum3Tf;
        IBOutlet UITextField* cardNum4Tf;
        IBOutlet UITextField* cardMonthTf;
        IBOutlet UITextField* cardYearTf;
        IBOutlet UILabel* expirePeriodLb;
        IBOutlet UILabel* cardTypeLb;
        IBOutlet UITextField* cardOwnerNumTf;
        IBOutlet UITextField* passwordTf;
        IBOutlet UIButton* cardInfoSaveBtn;
    // 그 외 결제 정보 
    IBOutlet UITextField* usePointTf;
    IBOutlet UILabel* payAmountLb;
    // 핸드폰 결제에 필요한 정보
    IBOutlet UIView* mobileInfoViewCol;
        IBOutlet UIButton* carrierBtn;
        IBOutlet UITextField* ssn1Tf; // 주민번호 앞자리 
        IBOutlet UITextField* ssn2Tf; // 주민번호 뒷자리
    
    // payBtn 을 포함한 인증정보 
    IBOutlet UIView* payBtnViewCol;
        IBOutlet UIButton* payBtn;
        IBOutlet UIButton* paygateTermBtn; // 약관 자세히 보기 버튼
        IBOutlet UIButton* termAgreeBtn; // 약관동의여부버튼
    IBOutlet UILabel* payProcessIngLb;
    ServerHelper* serverHelper;
    
    BOOL agreeTermCheck, agreeCardInfoSave;
    
    
    


}
@property (nonatomic, retain) UITapGestureRecognizer* tap;
@property (nonatomic) int selectedPurchaseOption;
@property (nonatomic, retain) DealItem* deal;
@property (retain) NSLock *payLock;
- (void)showAndRepositionPayProcessIngLb;
- (void)processTransactionFail:(NSString*)msg;
- (void)setDeal:(DealItem*)deal;
- (void)showPicker:(PickerType)type;
- (BOOL)isPurchaseOK;
+ (int)_min:(int)a with:(int)b ;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)pickerButtonClicked:(id)sender;
- (void)showAndRepos:(UIView*)inView withY:(float)newY;
- (void)hideCardInfo;
- (void)showCardInfo;
- (void)hideMobilePurchaseInfo;
- (void)hideOtherPurchaseOption;
- (void)showMobilePurchaseInfo;
- (void)showPointPurchaseOption;
- (void)returnToDealDetail;
@end
