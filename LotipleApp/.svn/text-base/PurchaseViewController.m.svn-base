//
//  PurchaseViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 19..
//  Copyright 2011 Home. All rights reserved.
//

#import "PurchaseViewController.h"
#import "LTPUITextField.h"
#import "UserManager.h"
#import "Settings.h"
#import "Cards.h"
#import "DealItem.h"
#import "Util.h"
#import "OAToken.h"
#import "LotipleAppAppDelegate.h"
#import "ServerConnection.h"
#import "PurchaseWebViewController.h"
#import "LoginViewController.h"
#import "TextUtil.h"
#import "NSString+URLEncoding.h"
#import "DetailViewController.h"
#import "TranManager.h"
#import "LTPConstant.h"
#import "JSONKit.h"
#import "ServerUrls.h"
#import "MoreWebViewController.h"

@implementation PurchaseViewController
@synthesize deal, selectedPurchaseOption, payLock , tap;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[deal release];
    [payBtn release];
    [carrierName release];
    [purchaseOption release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)server_tranRegister:(NSMutableDictionary*)params
{
    NSString* url = @TRAN_REGISTER_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
}


- (void)processTransactionFail:(NSString*)msg
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [Util showAlertView:nil message:msg];
    [payBtn setHidden:NO];
    [payProcessIngLb setHidden:YES];
}

- (void)processTransactionSuccess
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [Util showAlertView:nil message:@"결제에 성공했습니다."];
    [self returnToDealDetail];
}

- (void)calculatePayAmount
{
    // 결제정보
    int use_point = [usePointTf.text intValue];
    int count = selectedCount;
	int totalprice = count * [deal reduced_price] - use_point;
    payAmountLb.text = [TextUtil getFormattedPrice:totalprice];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    carrierName = [[NSArray alloc] initWithObjects:@"SKT",@"KT",@"LGU+",nil];
    [payProcessIngLb setHidden:YES];
    transaction_id = nil;
    selectedCount = 1;
    usePointTf.text = 0;
    	
    // 구매방식 정보 추가
    if (  [[ServerConnection instance] purchaseOptionCnt] == 3  ) 
        purchaseOption = [[NSArray alloc] initWithObjects:@"신용카드",@"전액포인트",@"핸드폰",nil];
    else 
        purchaseOption = [[NSArray alloc] initWithObjects:@"신용카드",@"전액포인트",nil];
    selectedPurchaseOption = POPTION_NONE;
    [purchaseOption retain];
    
	// scroll view
	[innerView setContentSize:innerView.frame.size];
	[innerView setFrame:[self.view frame]];
	
    // ServerHelper 
    serverHelper = [[ServerHelper alloc] initWithDelegate:self];
	
    // 유저 정보
    //[ [ServerConnection instance] fillUserinfo];
    UserManager* user = [UserManager instance];
    nameTf.text = user.name;
    phoneTf.text = [user.mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
    emailTf.text = user.email;
    pointLb.text = [NSString stringWithFormat:@"%d", user.point];

    [self calculatePayAmount];
      
    // 카드 정보
    Settings* settings = [Settings instance];
    cardNum1Tf.text = settings.cardNum1;
    cardNum2Tf.text = settings.cardNum2;
    cardNum3Tf.text = settings.cardNum3;
    cardNum4Tf.text = settings.cardNum4;
    cardMonthTf.text = settings.cardMonth;
    cardYearTf.text = settings.cardYear;
    NSLog(@"settings.cardType is %@", settings.cardType);
    [cardCb setTitle:settings.cardType forState:UIControlStateNormal];
	
	
	if (deal)
	{
		[self setDeal:deal];
	}
    
    self.title = @"구매하기";
    selectedPurchaseOption = POPTION_CARD;
    [self hideMobilePurchaseInfo];
    [self showCardInfo];
    
    agreeTermCheck = YES;
    agreeCardInfoSave = NO;
      
}

- (void)hideCardInfo
{
    [cardInfoViewCol setHidden:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setDeal:(DealItem*)aDeal
{
	[deal release];
	deal = [aDeal retain];

    titleLb.text = [TextUtil stringByDecodingXMLEntities:[deal title]];
	[countCb setTitle:@"1매" forState:UIControlStateNormal];
	
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];    
	priceLb.text = [[frmtr stringFromNumber:[NSNumber numberWithInt:[deal reduced_price]]] stringByAppendingString:@"원"];
    [frmtr release];
    
}

- (void)showPicker:(PickerType)type
{
	pickerType = type;
	[pickerPickerView reloadAllComponents];
    // 항상 초기 위치를 0으로 초기화
	[pickerPickerView selectRow:0 inComponent:0 animated:YES];
	pickerAs = [[UIActionSheet alloc] initWithTitle:@""
										   delegate:nil//self
								  cancelButtonTitle:nil//@"Done"
							 destructiveButtonTitle:nil//@"Cancel"
								  otherButtonTitles:nil];
	
	[pickerAs addSubview:mypickerView];
	
	[pickerAs setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	[pickerAs showInView:self.view];
	[pickerAs setBounds:CGRectMake(0,0,320, 436 + 45)];	
}

- (BOOL)isPurchaseOK
{
    NSString* message = nil;
    UITextField* focus = nil;
    int count = selectedCount;
    int point_use = [usePointTf.text intValue];
    NSString* _carrierName = [carrierBtn titleForState:UIControlStateNormal];
    int totalprice = count * [deal reduced_price];
    NSString* phone = phoneTf.text;
    NSString* username = nameTf.text;
    NSString* password = passwordTf.text;
    NSString* ssn = cardOwnerNumTf.text;
    NSString* cardMonth = cardMonthTf.text;
    NSString* cardYear = cardYearTf.text;
    UserManager* user = [UserManager instance];
    if ( selectedPurchaseOption != POPTION_POINT && totalprice - point_use < 1000 ) 
    { 
        message = @"포인트 분할결제시에 결제금액은 1000원이상이어야합니다.";
    }
    else if ( point_use > user.point )
    {
        message = @"포인트가 부족합니다." ;
    }
    else if ( point_use < 0 ) 
    {
        message = @"포인트 사용액은 음수일 수 없습니다.";
    }
    else if ( agreeTermCheck == NO )
    {
        message = @"이용약관에 동의해주십시오";
    }
    else if (!count)
    {
        message = @"개수를 입력해주십시오";
    }
    else if (![username length])
    {
        message = @"이름을 입력해주십시오";
        focus = nameTf;
    }
    else if (![phone length])
    {
        message = @"핸드폰 번호를 입력해주십시오";
        focus = phoneTf;
    }
    else if ( [cardYear length] != 4 && selectedPurchaseOption == POPTION_CARD )
    {
        message = @"유효기간을 입력해주십시오";
        focus = cardYearTf;
    }
    else if ( [cardMonth length] != 2 && selectedPurchaseOption == POPTION_CARD )
    {
        message = @"유효기간을 입력해주십시오";
        focus = cardMonthTf;
    }
    else if ( [password length] != 2 && selectedPurchaseOption == POPTION_CARD )
    {
        message = @"비밀번호 앞 2자리를 입력해주십시오";
        focus = passwordTf;
    }
    else if ( [ssn length] != 7 && selectedPurchaseOption == POPTION_CARD )
    {
        message = @"주민번호 뒤 7자리를 입력해주십시오";
        focus = cardOwnerNumTf;
    }
    else if ( selectedPurchaseOption == POPTION_NONE ) {
        message = @"결제방법을 선택해주십시오";
    }
    else if ( selectedPurchaseOption == POPTION_POINT ) {
        [ [UserManager instance] server_fillUserInfo];
        UserManager* user = [UserManager instance];
        if ( totalprice > user.point ) 
            message = @"포인트가 부족합니다.";
    }
    else if ( selectedPurchaseOption == POPTION_MOBILE ) {
        if ( [ssn1Tf.text length] != 6 ) {
            message =@"주민번호를 입력해주십시오";
            focus = ssn1Tf;
        }
        if ( [ssn2Tf.text length] != 7 ) {
            message =@"주민번호를 입력해주십시오";
            focus = ssn2Tf;
        }
        if ( [_carrierName length] < 2 ) {
            message =@"통신사를 입력해주십시오";
        }
    }
        
    if (message)
    {
        [Util showAlertView:self message:message];
    }
    
    if (focus)
    {
        [focus becomeFirstResponder];
    }
    
    if (message || focus)
    {
        return NO;
    }
    return YES;

}

- (void)fill_dealPurchaseInfo:(NSMutableDictionary*) params
{
    int count = selectedCount;
	int totalprice = count * [deal reduced_price];
    int point_use = [usePointTf.text intValue];
    int deal_id = [deal _id];
    if ( selectedPurchaseOption == POPTION_POINT ) {
        [params setObject:[ [ [TextUtil stringByDecodingXMLEntities:[deal title]] URLEncodedString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]forKey:@"goodname"];
    }
    else {
        NSError *error = NULL;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"[~!@#$%^&*=+|:;?\"<,.>'{}]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *replace_target = [[deal title] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *replaced_target= [regexp stringByReplacingMatchesInString:replace_target options:0 range:NSMakeRange(0, [replace_target length ]) withTemplate:@""];
        [params setObject:replaced_target forKey:@"goodname"];
    }
	[params setObject:int2str(totalprice - point_use) forKey:@"unitprice"]; // paygate 에서 결제하는 금액
    [params setObject:int2str(totalprice) forKey:@"total_price"]; 
	[params setObject:int2str(count) forKey:@"count"];
    [params setObject:int2str(deal_id) forKey:@"deal_id"];
    [params setObject:int2str(point_use) forKey:@"point_use"];
}

- (void)fill_userPurchaseInfo:(NSMutableDictionary*) params
{
	NSString* username = nameTf.text;
	NSString* phone = phoneTf.text;
	NSString* email = emailTf.text;
    // TODO: ...
    int user_id = [[UserManager instance] _id];
    CLLocation* buyLocation = [[ServerConnection instance] lastLocation];
    CLLocationCoordinate2D locationCord = [buyLocation coordinate];
    int x = locationCord.longitude*1000000;
    int y = locationCord.latitude*1000000;
    ServerConnection* conn = [ServerConnection instance];
    OAToken* token = [conn requestToken];
    NSString* digest = [conn sha256:[NSString stringWithFormat:@"%@%@", [token key], [token secret]]];

    [params setObject:[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"receipttoname"];
	[params setObject:phone forKey:@"receipttotel"];
	[params setObject:email forKey:@"receipttoemail"];
    [params setObject:int2str(x) forKey:@"x"];
	[params setObject:int2str(y) forKey:@"y"];
	[params setObject:@"2" forKey:@"route"]; // 아이폰의 경우 route 가 2임
    [params setObject:[token key] forKey:@"oauth_token"];
    [params setObject:digest forKey:@"secret"];
    [params setObject:[TextUtil getVerStr] forKey:@"app_ver"];
    [params setObject:[username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"buyer_name"];
	[params setObject:phone forKey:@"buyer_mobile"];
	[params setObject:email forKey:@"buyer_email"];
	[params setObject:@"true" forKey:@"is_mobile_app"];
    [params setObject:int2str(user_id) forKey:@"user_id"];

    return ;
}

- (void)saveCardInfo
{
    Settings* settings = [Settings instance];
    settings.cardNum1 = cardNum1Tf.text;
    settings.cardNum2 = cardNum2Tf.text;
    settings.cardNum3 = cardNum3Tf.text;
    settings.cardNum4 = cardNum4Tf.text;
    settings.cardMonth = cardMonthTf.text;
    settings.cardYear = cardYearTf.text;
    settings.cardType = [cardCb titleForState:UIControlStateNormal];
}

- (void)server_purchaseCard:(NSMutableDictionary*)params
{

    NSString *payment_method = @"0"; // 0 PAYMENT_CARD 신용카드
    [params setObject:payment_method forKey:@"payment_method"]; 
    NSLog(@"card cd titleforstate is %@", [cardCb titleForState:UIControlStateNormal]);
    int cardcode = [Cards codeForName:[cardCb titleForState:UIControlStateNormal]];
    NSString* cardnumber = [NSString stringWithFormat:@"%@%@%@%@",
                            cardNum1Tf.text, cardNum2Tf.text,
                            cardNum3Tf.text, cardNum4Tf.text];
    
    NSString* cardmonth = cardMonthTf.text;
    NSString* cardyear = cardYearTf.text;
    NSString* ownerNum = cardOwnerNumTf.text;
    NSString* cardSecretNum = passwordTf.text;
    NSString* username = nameTf.text;
    NSString* url =@PURCHASE_CARD_REQUEST;
    NSString* mb_serial_no;
    if ( [[ServerConnection instance ] developMode] == NO )
        mb_serial_no = [NSString stringWithFormat:@"lotiple_%@",transaction_id];
    else
        mb_serial_no = [NSString stringWithFormat:@"test_lotiple_%@",transaction_id];
    // TODO : should be removed
//    NSLog(@"ownernum is %@ and secret is %@", ownerNum, cardSecretNum);
    [params setObject:int2str(cardcode) forKey:@"cardtype"];
    [params setObject:cardyear forKey:@"cardyear"];
    [params setObject:cardnumber forKey:@"cardnumber"];
    [params setObject:cardmonth forKey:@"cardexpiremonth"];
    [params setObject:cardyear forKey:@"cardexpireyear"];
    [params setObject:ownerNum forKey:@"cardownernumber"];
    [params setObject:cardSecretNum forKey:@"cardsecretnumber"];
    [params setObject:@LOTIPLE_MID forKey:@"mid"];
    [params setObject:@BASIC_AUTH forKey:@"paymethod"];
    // goodname 과 이름은 euc-kr 로 다시 넣어야함 ㅡㅡ;;;
    [params setObject:[deal title] forKey:@"goodname"];
    [params setObject:username forKey:@"receipttoname"];
    [params setObject:mb_serial_no forKey:@"mb_serial_no"];
    
    if ( agreeCardInfoSave == YES ) {
        [self saveCardInfo];
    }
    // paygate post request 
   [serverHelper sendPostRequest:url andParams:params];
}


- (void)server_purchaseMobile:(NSMutableDictionary*)params
{
    NSString *payment_method = @"2"; //  PAYMENT_MOBILE 핸드폰 결제
    [params setObject:payment_method forKey:@"payment_method"];
    
    // 통신사 정보
    NSString* _carrierName = [carrierBtn titleForState:UIControlStateNormal];
    [params setObject:[TextUtil getCarrierCode:_carrierName] forKey:@"carrier"];
    
    // 주민번호
    [params setObject:[NSString stringWithFormat:@"%@%@",ssn1Tf.text,ssn2Tf.text] forKey:@"socialnumber"];
    
    // paymethod 설정
    [params setObject:@"801" forKey:@"paymethod"];

    NSString* post = [TextUtil createParamString:params];
    NSString* requestURL = [NSString stringWithFormat:@"%@%@?%@", [[ServerConnection instance] serverUrl], @PURCHASE_MOBILE_REQUEST,post];
    
    NSLog(@"requestURL is %@", requestURL);

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]] ;
    
    NSData* postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString* postLength = [NSString stringWithFormat:@"%d", [postData length]];
     
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];

    NSLog(@"request ");
    PurchaseWebViewController* purchaseWebView = [[PurchaseWebViewController alloc] initWithRequest:request];
    [self.navigationController pushViewController:purchaseWebView animated:YES];
    [purchaseWebView release];

}

- (void)server_purchasePoint:(NSMutableDictionary*)params
{
    NSString *payment_method = @"3"; // PAYMENT_POINT 포인트 결제
    [params setObject:payment_method forKey:@"payment_method"];
    int count = selectedCount;
    int point_use = count * [deal reduced_price];
    [params setObject:int2str(point_use) forKey:@"point_use"];
    [params setObject:@"buy_with_point" forKey:@"func"];
    NSString* url =@PURCHASE_POINT_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];

}

- (void)tryPurchase2
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:18];
    [self fill_userPurchaseInfo:params];
    [self fill_dealPurchaseInfo:params];
    
    if ( selectedPurchaseOption == POPTION_CARD) 
    {
        [self showAndRepositionPayProcessIngLb];
        [self server_tranRegister:params];
    }
    else if ( selectedPurchaseOption == POPTION_MOBILE)
    {
        [self server_purchaseMobile:params];
    }
    else if ( selectedPurchaseOption == POPTION_POINT )
    {
        [self showAndRepositionPayProcessIngLb];
        [self server_purchasePoint:params];
        
    }
    [params release];
}

- (void)openTerms
{
    MoreWebViewController* webView = [[MoreWebViewController alloc] initWithTitleText:@"결제대금예치서비스 이용약관"];
    NSString* urlParam = [NSString stringWithFormat:@"https://api.paygate.net/ajax/common/PGServiceContract.html" ];
    [webView openUrl:urlParam];

    [[self navigationController] pushViewController:webView animated:YES];
    [webView release];		    
}

- (void)handleCardInfoSaveBtn
{
    if ( agreeCardInfoSave == YES ) {
        [cardInfoSaveBtn  setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        agreeCardInfoSave = NO;
    }
    else
    {
        [cardInfoSaveBtn  setImage:[UIImage imageNamed:@"checkbox-fill.png"] forState:UIControlStateNormal];
        agreeCardInfoSave = YES;
    }

}

- (void)handleTermAgreeBtn
{
    if ( agreeTermCheck == YES ) {
        [termAgreeBtn  setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        agreeTermCheck = NO;
    }
    else
    {
        [termAgreeBtn  setImage:[UIImage imageNamed:@"checkbox-fill.png"] forState:UIControlStateNormal];
        agreeTermCheck = YES;
    }
}

- (void)showAndRepositionPayProcessIngLb
{
    [payBtn setHidden:YES];
    [payProcessIngLb setHidden:NO];
}


#pragma mark - Event handlers

- (IBAction)buttonClicked:(id)sender
{
	if (sender == countCb)
	{
		[self showPicker:PickerTypeCount];
	}
	else if (sender == purchaseCb)
	{
		[self showPicker:PickerTypePurchase];
	}
	else if (sender == payBtn)
	{
        if ( [self isPurchaseOK] == NO )
            return;
        [self tryPurchase2];
	}
    else if (sender == cardCb) 
    {
        [self showPicker:PickerTypeCard];
    }
    else if (sender == carrierBtn)
    {
        [self showPicker:PickerTypeCarrier];
    }
    else if (sender == paygateTermBtn)
    {
        [self openTerms];
    }
    else if ( sender == termAgreeBtn)
    {
        [self handleTermAgreeBtn];
    }
}
// picker 에서 수량 선택시에 호출됨
- (void) pickerCountAcceptBtnClicked
{
    NSString* count = [NSString stringWithFormat:@"%d매", selectedRow+1];
    [countCb setTitle:count forState:UIControlStateNormal];
    selectedCount = selectedRow + 1 ;
    if ( selectedRow + 1 > 1 )
        [noticeLb setText:@"주의:분할사용불가"];
    else
        [noticeLb setText:@""];
    
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];    
    priceLb.text = [[frmtr stringFromNumber:[NSNumber numberWithInt:([deal reduced_price] * (selectedRow+1))]] stringByAppendingString:@"원"];
    [frmtr release];
    [self calculatePayAmount];
}

// 구매옵션 선택시에 호출됨 
- (void) pickerTypePurchaseAceeptBtnClicked
{
    if ( selectedRow >= [purchaseOption count] )
        return;
    [purchaseCb setTitle:[purchaseOption objectAtIndex:selectedRow] forState:UIControlStateNormal];
    selectedPurchaseOption = selectedRow;
    [usePointTf setText:@"0"];
    [self calculatePayAmount];
    if ( selectedPurchaseOption == POPTION_CARD ) {
        [self hideOtherPurchaseOption];
        [self showCardInfo];
        usePointTf.enabled = YES;
    }
    else if ( selectedPurchaseOption == POPTION_MOBILE)
    {
        
        [self hideOtherPurchaseOption];
        [self showMobilePurchaseInfo];
        usePointTf.enabled = YES;
    }
    else if ( selectedPurchaseOption == POPTION_POINT) 
    {
        [self hideOtherPurchaseOption];
        [self showPointPurchaseOption];
        usePointTf.enabled = NO;
    }
}

- (IBAction)pickerButtonClicked:(id)sender
{
	if (sender == pickerCancelBtn)
	{
		;
	}
	else if (sender == pickerAcceptBtn)
	{
		if (pickerType == PickerTypeCount)
		{
            NSLog(@"pickerAccetBtn");
            [self pickerCountAcceptBtnClicked];
		}
		else if (pickerType == PickerTypePurchase)
		{
            [self pickerTypePurchaseAceeptBtnClicked];
        }
        else if (pickerType == PickerTypeCard )
        {
            NSString* cardName = [Cards nameForType:selectedRow];
            [cardCb setTitle:cardName forState:UIControlStateNormal];
        }
        else if (pickerType == PickerTypeCarrier)
        {
            [carrierBtn setTitle:[carrierName objectAtIndex:selectedRow] forState:UIControlStateNormal];
            [ssn1Tf becomeFirstResponder];
        }
	}
	[pickerAs dismissWithClickedButtonIndex:-1 animated:YES];
	[pickerAs release];
	pickerAs = nil;
}

- (void)hideOtherPurchaseOption
{
    [self hideCardInfo];
    [self hideMobilePurchaseInfo];
}

- (void)hideMobilePurchaseInfo
{
    [mobileInfoViewCol setHidden:YES];
}

- (void)showPointPurchaseOption
{
    int count = selectedCount;
    usePointTf.text = int2str ( count * [deal reduced_price]);
    [self calculatePayAmount];
    [self showAndRepos:payBtnViewCol withY:455];
}

- (void)showMobilePurchaseInfo
{
    [mobileInfoViewCol setHidden:NO];
    CGSize newContenetSize = innerView.contentSize;
    newContenetSize.height = 950;
    usePointTf.text = 0;
    innerView.contentSize = newContenetSize;
    [self showAndRepos:mobileInfoViewCol withY:455];
    [self showAndRepos:payBtnViewCol withY:590];
}

- (void)showCardInfo
{
    CGSize newContenetSize = innerView.contentSize;
    newContenetSize.height = 1070;
    innerView.contentSize = newContenetSize;
    [cardInfoViewCol setHidden:NO];
    usePointTf.text = 0;
    
    [self showAndRepos:cardInfoViewCol withY:455];
    [self showAndRepos:payBtnViewCol withY:700];
}

- (void)showAndRepos:(UIView*)inView withY:(float)newY
{
    [inView setHidden:NO];
    CGRect newFrame = inView.frame;
    newFrame.origin.y = newY;
    inView.frame = newFrame;    
}

- (IBAction)editingChanged:(id)sender;
{
	UITextField* textField = (UITextField*)sender;
	
	// 뭐..이런건 그냥 하드코딩이 진리
	NSUInteger length = [textField.text length];
	
	if (length == 4)
	{
		if (textField == cardNum1Tf)
			[cardNum2Tf becomeFirstResponder];
		if (textField == cardNum2Tf)
			[cardNum3Tf becomeFirstResponder];
		if (textField == cardNum3Tf)
			[cardNum4Tf becomeFirstResponder];
		if (textField == cardNum4Tf)
			[cardMonthTf becomeFirstResponder];
        if (textField == cardYearTf)
            [cardOwnerNumTf becomeFirstResponder];
	}
    if ( length ==2 )
    {
        if (textField == cardMonthTf)
			[cardYearTf becomeFirstResponder];
    }
    if ( length == 6 )
    {
        if (textField == ssn1Tf)
            [ssn2Tf becomeFirstResponder];
    }
    if ( length == 7 )
    {
        if (textField == cardOwnerNumTf )
            [passwordTf becomeFirstResponder];
    }
    if (textField == usePointTf && selectedPurchaseOption != POPTION_POINT) 
    {
        int use_point = [usePointTf.text intValue];
        int count = selectedCount;
        int totalprice = count * [deal reduced_price];
        NSLog(@"use point is %d totalprice is %d", use_point, totalprice);
        if ( use_point == totalprice ) {
            // 포인트 전액결제로 변경
            selectedPurchaseOption = POPTION_POINT;
            selectedRow = 1;
            [purchaseCb setTitle:[purchaseOption objectAtIndex:selectedRow] forState:UIControlStateNormal];
            [self hideOtherPurchaseOption];
            [self showPointPurchaseOption];
            usePointTf.enabled = NO;
        }
        [self calculatePayAmount];
    }
}



#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"titleForRow %d", row );
	if (pickerType == PickerTypeCount)
	{
		return [NSString stringWithFormat:@"%d", row+1];
	}
	else if ( pickerType == PickerTypePurchase ) 
	{
		return [purchaseOption objectAtIndex:row];
	}
    else if ( pickerType == PickerTypeCard)
    {
        return [Cards nameForType:(CardType)row];
    }
    else if ( pickerType == PickerTypeCarrier )
    {
        return [carrierName objectAtIndex:row];
    }
	
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"didSelectRow");
	
    selectedRow = row;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

+ (int)_min:(int)a with:(int)b 
{
    if ( a < b )
        return a;
    return b;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (pickerType == PickerTypeCount)
	{
        // 개수는 1 ~ 10
        if ( [deal max_count] - [deal current_ordered_count] < 10 )
            return [PurchaseViewController _min : [deal max_count] - [deal current_ordered_count] with:[deal count_limit]];
        if ( [deal count_limit] < 10 )
            return [deal count_limit];
        return 10;
	}
	else if (pickerType == PickerTypePurchase )
	{
		return [purchaseOption count];
	}
    else if (pickerType == PickerTypeCard)
    {
        return CardTypeCount;
    }
    else if (pickerType == PickerTypeCarrier)
    {
        return 3;
    }
		
	return 0;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%s",__FUNCTION__);
	[textField resignFirstResponder];
	return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%s",__FUNCTION__);
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	
	int cutline = 0;
	
	
	if (textField == cardMonthTf) cutline = 2;
	else if (textField == cardNum1Tf || textField == cardNum2Tf ||
			 textField == cardNum3Tf || textField == cardNum4Tf || textField == cardYearTf)
		cutline = 4;
    else if ( textField == cardOwnerNumTf )
        cutline = 7;
    else if ( textField == passwordTf )
        cutline = 2;
	
	if (cutline == 0)
		return YES;
	return (newLength <= cutline);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint offset = CGPointMake(0,0);
    
    if ( textField == cardOwnerNumTf )
        offset = CGPointMake(0,610);
    else if (textField == passwordTf )
        offset = CGPointMake(0,655);
    else if (textField == cardNum1Tf || textField == cardNum2Tf || textField == cardNum3Tf || textField == cardNum4Tf)
        offset = CGPointMake(0,500);
    else if (textField == nameTf)
        offset = CGPointMake(0,175);
    else if (textField == phoneTf)
        offset = CGPointMake(0,210);
    else if (textField == emailTf)
        offset = CGPointMake(0,245);
    else if (textField == ssn1Tf  || textField == ssn2Tf)
        offset = CGPointMake(0,500);
    else if (textField == usePointTf)
        offset = CGPointMake(0,315);
    else if (textField == cardMonthTf)
        offset = CGPointMake(0,535);
    if ( offset.y > 0 )
        [innerView setContentOffset:offset animated:YES];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%s",__FUNCTION__);
	if (textField == cardMonthTf)
	{
		int month = [cardMonthTf.text intValue];
		if (month < 10)
			cardMonthTf.text = [NSString stringWithFormat:@"%02d", month];
	}
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [usePointTf resignFirstResponder];
    [nameTf resignFirstResponder];
    [phoneTf resignFirstResponder];
    [emailTf resignFirstResponder];
    [cardNum1Tf resignFirstResponder];
    [cardNum2Tf resignFirstResponder];
    [cardNum3Tf resignFirstResponder];
    [cardNum4Tf resignFirstResponder];
    [cardMonthTf resignFirstResponder];
    [cardYearTf resignFirstResponder];
    [cardOwnerNumTf resignFirstResponder];
    [passwordTf resignFirstResponder];
    [ssn1Tf resignFirstResponder];
    [ssn2Tf resignFirstResponder];
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		NSLog(@"button index 0 ");
	}
	else if (buttonIndex == 1)
	{      
        LoginViewController* loginView =[[LoginViewController alloc ] init ]; 
        [loginView.view retain];
        [loginView.view release];
        
        [[self navigationController] pushViewController:loginView animated:YES];
        [loginView release];
	}
    else
        NSLog(@"button rest ..");
}

-(void)returnToDealDetail
{
    [self.navigationController popViewControllerAnimated:YES]; 
}

-(NSMutableDictionary*)createResponseDic:(NSArray*)responseChunk
{
    NSMutableDictionary* responseDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    for ( NSString* key_value in responseChunk )
    {
        NSArray* key_value_ele = [key_value componentsSeparatedByString:@"="];
        @try {
            NSString* key = [key_value_ele objectAtIndex:0];
            NSString* value = [key_value_ele objectAtIndex:1];
            [responseDic setObject:value forKey:key];
        }
        @catch (NSException *exception) {
            continue;
        }
    }
    return responseDic;
}


#pragma mark - Response Handler
-(void)handle_purchaseCard:(NSData*)responseData
{
    NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:EUC_KR] autorelease];
    NSLog(@"responseString is ///%@///", responseString);
    NSArray* responseChunk = [ responseString componentsSeparatedByString:@"&"];
    // create responseDic
    NSMutableDictionary *responseDic = [self createResponseDic:responseChunk];
    if ( [[responseDic objectForKey:@"ReplyCode"] isEqualToString:@PAYGATE_REPLYCODE_SUCCESS] ) 
    {
        [self processTransactionSuccess];
    }
    else
    {
        NSString* msg = [NSString stringWithFormat:@"결제에 실패했습니다. %@", [responseDic objectForKey:@"ReplyMsg"]];
        [self processTransactionFail:msg];

    }
    
}

-(void)handle_purchasePoint:(NSData*)responseData
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString* response_code = [response_all objectForKey:@"code"];
    if ( [@"OK" isEqualToString:response_code ] )
    {
        [self processTransactionSuccess];
    }
    else
    {
        NSString* response_msg = [response_all objectForKey:@"msg"];
        [self processTransactionFail:[NSString stringWithFormat:@"결제에 실패했습니다. %@",response_msg]];
    }
   
}

-(void)handle_tranRegister:(NSData*)responseData
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString* response_code = [response_all objectForKey:@"code"];
    if ( [@"OK" isEqualToString:response_code])
    {
        NSDictionary* response_data = [response_all objectForKey:@"data"];
        transaction_id = [[response_data objectForKey:@"transaction_id"] copy];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:18];
        // 우리쪽 transaction register 성공했으니까 paygate 한테 물어본다. 
        [self fill_userPurchaseInfo:params];
        [self fill_dealPurchaseInfo:params];
        [self server_purchaseCard:params];
        [params release];
    }
    else
    {
        NSString* response_msg = [response_all objectForKey:@"msg"];
        [self processTransactionFail:[NSString stringWithFormat:@"결제초기화 실패했습니다. %@", response_msg]];        
    }
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url 
{
    NSLog(@"%s",__FUNCTION__);    
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@PURCHASE_POINT_REQUEST].location != NSNotFound )
    {
        [self handle_purchasePoint:responseData];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@PURCHASE_CARD_REQUEST].location != NSNotFound )
    {
        [self handle_purchaseCard:responseData];
    }
    else if ( [[chunks objectAtIndex:0] rangeOfString:@TRAN_REGISTER_REQUEST].location != NSNotFound )
    {
        [self handle_tranRegister:responseData];
    }
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg;
{
    NSLog(@"%s",__FUNCTION__);
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [payBtn setHidden:NO];
    [payProcessIngLb setHidden:YES];
    // 구매 망했음 msg 필요함
    [Util showAlertView:nil message:@"인터넷 연결을 확인하시고 다시 구매를 시도해주세요."];
    
}

@end
