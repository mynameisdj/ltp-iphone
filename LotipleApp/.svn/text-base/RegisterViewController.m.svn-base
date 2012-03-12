//
//  RegisterViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 5. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import "RegisterViewController.h"

#import "LotipleAppAppDelegate.h"
#import "ServerConnection.h"
#import "MoreWebViewController.h"
#import "Settings.h"
#import "LTPConstant.h"
#import "ServerUrls.h"
#import "JSONKit.h"
#import "UserManager.h"
#import "Util.h"
#import "ServerConnection.h"

#define BUY_TERM 1
#define LOCATION_TERM 2
#define PERSONAL_TERM 3

@implementation RegisterViewController
@synthesize okSw, pickerType, selectedRow, selectedGender, selectedBirthYear, friendNameLb, friendDescLb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        confirmMobile = @"";
    }
    return self;
}

- (void)dealloc
{
    [genderElements release];
    [birthYearElements release];
    [submitBtn release];
    [carrierElements release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)initPickerElement
{
    genderElements = [[NSArray alloc] initWithObjects:@"남",@"여", nil]; 
    birthYearElements = [[NSMutableArray alloc] init];
    carrierElements = [[NSArray alloc] initWithObjects:@"010",@"011",@"016",@"017",@"018",@"019",nil];
    
    for ( int i = 1940 ; i < 2000 ; i++)
    {
        NSString *newYear = [NSString stringWithFormat:@"%d", i]; 
        [birthYearElements addObject:newYear];
    }
    selectedGender = -1;
    selectedBirthYear = -1;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    serverHelper = [[ServerHelper alloc] initWithDelegate:self];
    [self initPickerElement];
    [self.navigationItem setTitle:@"회원가입"];
    [friendNameLb setHidden:YES];
    [friendDescLb setHidden:YES];
    isphoneNumConfirmed = NO;
    
    // scroll view
	[self.view addSubview:innerView];    
    innerView.delegate =self;
	[innerView setContentSize:innerView.frame.size];
	[innerView setFrame:CGRectMake(0, 58, 320, 430)];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView { 
    [emailTf resignFirstResponder];
    [nameTf resignFirstResponder];
    [pwTf resignFirstResponder];
    [pw2Tf resignFirstResponder];
    [phone2Tf resignFirstResponder];
    [phone3Tf resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) showTabbar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) hideTabbar];

    [LotipleUtil trackPV:@"/register"];
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

- (BOOL)isRegisterOK
{
    NSString* email = emailTf.text;
	NSString* name = nameTf.text;
	NSString* pw1 = pwTf.text;
	NSString* pw2 = pw2Tf.text;
	NSString* phone = [NSString stringWithFormat:@"%@%@%@",[carrierBtn titleLabel].text,[phone2Tf text],[phone3Tf text]];
    
	// 클라이언트 사이드 벨리데이션
	
    NSString* message = nil;
    
    if (![email length])
    {
        message = @"이메일을 입력해주세요";
        [emailTf becomeFirstResponder];
    }
    else if (![name length])
    {
        message = @"이름을 입력해주세요";
        [nameTf becomeFirstResponder];
    }
    else if (![pw1 length])
    {
        message = @"비밀번호를 입력해주세요";
        [pwTf becomeFirstResponder];
    }
    else if (![pw2 length])
    {
        message = @"비밀번호을 입력해주세요";
        [pw2Tf becomeFirstResponder];
    }
    else if (![phone length])
    {
        message = @"휴대폰 번호를 입력해주세요";
        [confirmPhoneBtn becomeFirstResponder];
    }
    // 비밀번호 틀린것 확인 
    else if (![pw1 isEqualToString:pw2])
    {
        message = @"비밀번호가 틀렸습니다";
        [pwTf becomeFirstResponder];
    }
    else if ( selectedGender == -1 )
    {
        message = @"성별을 등록해주십시오.";
    }
    else if ( selectedBirthYear == -1)
    {
        message = @"태어난해를 입력해주십시오.";
    }
    else if (isphoneNumConfirmed == NO)
    {
        message = @"핸드폰 인증을 받아주십시오.";
    }
    
    if (message)
    {
        NSLog(@"오류가 있는 상황");
        [Util showAlertView:self message:message];
        return NO;
    }
    return YES;	
}

#pragma mark - server Operation
-(void)server_registerSubmit
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSString* email = emailTf.text;
	NSString* name = nameTf.text;
	NSString* pw1 = pwTf.text;
	NSString* phone = [NSString stringWithFormat:@"%@%@%@",[carrierBtn titleLabel].text,[phone2Tf text],[phone3Tf text]];
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    [params setObject:email forKey:@"email"];
    [params setObject:name forKey:@"name"];
    [params setObject:phone forKey:@"mobile"];
    [params setObject:pw1 forKey:@"password"];
    [params setObject:int2str(selectedGender) forKey:@"sex"];
    [params setObject:int2str(selectedBirthYear) forKey:@"birthyear"];
    [params setObject:@"1" forKey:@"favorite_area"];
    [params setObject:@"buyer" forKey:@"register_type"];
    [params setObject:@"1" forKey:@"agree_adv_sms"];
    [params setObject:@"1" forKey:@"agree_adv_email"];
    NSString* url = @USER_REGISTER_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
    
}


- (void)tryRegister
{
    if ( [self isRegisterOK] == NO )
        return ;
	Settings* settings = [Settings instance];
    settings.saveId = YES;
    settings.usedId = emailTf.text;
    settings.usedPw = pwTf.text;
    [settings save];
    [self server_registerSubmit];
}

- (void)didInviteFriendEnd
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)handle_registerSubmit:(NSData*)responseData
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString* response_code = [response_all objectForKey:@"code"];
    NSString* response_msg = [response_all objectForKey:@"msg"];
	
//	Return:
//	“OK”: 회원 가입 완료
//	
//	error 메세지
//	"NOT_REGISTERED": 회원 가입에 실패 하였습니다.
//    "EMAIL_MALFORMED": 잘못된 형식의 이메일 주소 입니다.
//	"EMAIL_DUPLICATED": 이메일 주소가 중복 되었습니다.
//    "INVALID_MOBILE_NUM": 잘못된 형식의 휴대폰 번호를 입력하셨습니다.
    NSString* message = @"";
	if ([response_code isEqualToString:@"OK"])
	{			
        message = @"회원가입완료";
        NSString* user_id = emailTf.text;; 
        NSString* user_pw = pwTf.text;
        [[UserManager instance] server_login:user_id password:user_pw delegate:self];
	}
	else if ([response_code isEqualToString:@"EMAIL_MALFORMED"])
	{
		message = @"잘못된 형식의 이메일 주소입니다";
		[emailTf becomeFirstResponder];
	}
	else if ([response_code isEqualToString:@"EMAIL_DUPLICATED"])
	{
		message = @"이메일 주소가 중복되었습니다";
		[emailTf becomeFirstResponder];
	}
	else if ([response_code isEqualToString:@"INVALID_MOBILE_NUM"])
	{
		message = @"잘못된 형식의 휴대폰 번호를 입력하였습니다";
		[confirmPhoneBtn becomeFirstResponder];
	}
	else if ([response_code isEqualToString:@"NEED_LOGOUT"])
	{
		message = @"로그인 상태에서는 계정을 등록할 수 없습니다";
	}
    else if ([response_code isEqualToString:@"MOBILE_DUPLICATED"])
	{
		message = @"중복된 전화번호로는 가입할 수 없습니다.";
	}
	else 
	{
		message = [NSString stringWithString:response_msg];
	}
    [Util showAlertView:self message:message];
	return ;
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSLog(@"ServerOperationSuccess %@", [url absoluteString] );
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@USER_REGISTER_REQUEST].location != NSNotFound )
    {
        NSLog(@"ServerInfo");
        [self handle_registerSubmit:responseData];
    }
    [LotipleAppAppDelegate showBusyIndicator:NO];

}
- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"ServerOperationFail");
    [LotipleAppAppDelegate showBusyIndicator:NO];
}

#pragma mark - Event handlers

- (IBAction)buttonClicked:(id)sender
{
	if (sender == submitBtn)
	{
		[self tryRegister];
	}
    else if (sender == viewTermsBtn)
    {
        [self viewTerms:BUY_TERM];
    }
    else if (sender == viewTermsBtn2)
    {
        [self viewTerms:LOCATION_TERM];
    }
    else if (sender == viewTermsBtn3)
    {
        [self viewTerms:PERSONAL_TERM];
    }
    else if (sender == genderBtn)
	{
        NSLog(@"genderBtn");
		[self showPicker:PickerTypeGender];
	}
    else if (sender == birthYearBtn)
    {
        NSLog(@"birthYearBtn");
        [self showPicker:PickerTypeBirthYear];
    }
    else if (sender == confirmPhoneBtn)
    {
        NSLog(@"confirmPhoneBtn");
        [self viewPhoneConfirm];
    }
    else if (sender == carrierBtn) 
    {
        [self showPicker:PickerTypeCarrier];
    }

}

- (void)showPicker:(PickerType)type
{
    NSLog(@"showPicekr");
	pickerType = type;
	[pickerPickerView reloadAllComponents];
    if ( type == PickerTypeBirthYear ) 
    {
        // 태어난해 디폴트값 세팅 
        [pickerPickerView selectRow:43 inComponent:0 animated:NO];
        selectedRow = 43;
    }
    else if ( type == PickerTypeGender )
    {
        [pickerPickerView selectRow:0 inComponent:0 animated:NO];
        selectedRow = 0;
    }
    else if ( type == PickerTypeCarrier) 
    {
        [pickerPickerView selectRow:0 inComponent:0 animated:NO];
        selectedRow = 0;
    }
	
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


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint offset = CGPointMake(0, 0);
    if (textField == phone2Tf || textField == phone3Tf)
        offset = CGPointMake(0,175);
    else if (textField == nameTf )
        offset = CGPointMake(0,35 );
    else if (textField == pwTf )
        offset = CGPointMake(0,70);
    else if (textField == pw2Tf)
        offset = CGPointMake(0,105);
    if ( offset.y > 0 )
        [innerView setContentOffset:offset animated:YES];
}

- (IBAction)editingChanged:(id)sender
{
    UITextField* textField = (UITextField*)sender;
    NSUInteger length = [textField.text length];
    if ( textField == phone2Tf && length == 4) {
        [phone3Tf becomeFirstResponder];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

static NSString* PurchaseTerms = @"구매이용 약관";
static NSString* LocationTerms = @"위치기반서비스이용약관";
static NSString* PersonalTerms = @"개인정보 취급방침";

- (IBAction)viewTerms:(int)term_type
{
    MoreWebViewController* webView = [[MoreWebViewController alloc] init];
    if ( term_type == BUY_TERM ) {
        [webView setTitle:PurchaseTerms];
        [webView openUrl:@"http://www.lotiple.com/html/term1.html"];
        
    }
    else if ( term_type == LOCATION_TERM ) {
        [webView setTitle:LocationTerms];
        [webView openUrl:@"http://www.lotiple.com/html/term2.html"];
    }
    else if ( term_type == PERSONAL_TERM) {
        [webView setTitle:PersonalTerms];
        [webView openUrl:@"http://www.lotiple.com/html/term4.html"];
    }
    NSLog(@"font size up!");
    [[self navigationController] pushViewController:webView animated:YES];
    [webView release];		
}

- (BOOL)confirmNumberHandle:(NSString*)result
{
    NSString* message = nil; 
    if([result isEqualToString:@"OK"])
         return YES;
    else if ( [result isEqualToString:@"MOBILE_DUPLICATED"])
    {
        message = @"중복된 전화번호로는 가입할 수 없습니다.";
    }
    else if ( [result isEqualToString:@"INVALID_MOBILE_NUMBER"]) 
    {
        message = @"잘못된 형식의 휴대폰 번호를 입력하셨습니다.";
    }
    else 
    {
        message = @"인증도중 문제가 발생하였습니다. 콜센터로 문의하세요. 1577-1810";
    }
    
    if ( message ) 
    {
        [Util showAlertView:self message:message];
    }
    return NO;
    
}

- (IBAction)viewPhoneConfirm
{
    NSString* mobile = [NSString stringWithFormat:@"%@%@%@",[carrierBtn titleLabel].text,[phone2Tf text],[phone3Tf text]];
    NSString* result = [[ServerConnection instance] confirmPhoneNumber:mobile confirmNumber:nil];
    if ( [self confirmNumberHandle:result] == YES ) { 
        // TODO : 문자보내기 routine
        ConfirmInputViewController* confirmInputView = [[ConfirmInputViewController alloc] init];
        [confirmInputView setMobile:mobile];
        [confirmInputView setDelegate:self];
        NSLog(@"open confirm controller");
        [[self navigationController] pushViewController:confirmInputView animated:YES];
        [confirmInputView release];
    }}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"titleForRow %d", row );
	if (pickerType == PickerTypeGender)
	{
		return [genderElements objectAtIndex:row];
	}
	else if ( pickerType == PickerTypeBirthYear ) 
	{
		return [birthYearElements objectAtIndex:row];
	}
    else if ( pickerType == PickerTypeCarrier )
    {
        return [carrierElements objectAtIndex:row];
    }
	return @"";
}


- (IBAction)pickerButtonClicked:(id)sender
{
	if (sender == pickerCancelBtn)
	{
		;
	}
	else if (sender == pickerAcceptBtn)
	{
		if (pickerType == PickerTypeGender)
		{
            NSLog(@"%@",[genderElements objectAtIndex:selectedRow]);
            [genderBtn setTitle:[genderElements objectAtIndex:selectedRow] forState:UIControlStateNormal];
            selectedGender = selectedRow + 1; 
		}
		else if (pickerType == PickerTypeBirthYear) 
		{
            NSLog(@"%@",[birthYearElements objectAtIndex:selectedRow]);
            [birthYearBtn setTitle:[birthYearElements objectAtIndex:selectedRow] forState:UIControlStateNormal];
            selectedBirthYear = [[birthYearElements objectAtIndex:selectedRow] intValue];
        }
        else if (pickerType == PickerTypeCarrier)
        {
            [carrierBtn setTitle:[carrierElements objectAtIndex:selectedRow] forState:UIControlStateNormal];
        }
	}
	
	[pickerAs dismissWithClickedButtonIndex:-1 animated:YES];
	[pickerAs release];
	pickerAs = nil;
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (pickerType == PickerTypeGender)
	{    
        return [genderElements count];
	}
	else if ( pickerType == PickerTypeBirthYear) 
	{
		return [birthYearElements count];
	}
    else if ( pickerType == PickerTypeCarrier) 
    {
        return [carrierElements count];
    }
    return 0;
}

- (IBAction)beginEdit:(UITextField *)sender
{
    float offset_y = sender.frame.origin.y;
    float current_y = innerView.contentOffset.y;
    
    if( offset_y > 240 )
    {
        CGPoint new_offset;
        new_offset.x = 0;
        new_offset.y = current_y + (offset_y - 240);
        [innerView setContentOffset:new_offset animated:YES];
    }
}

- (void)successConfirm:(NSString*)friendName
{
    isphoneNumConfirmed = YES;
    [confirmPhoneBtn setHidden:YES];
    NSLog(@"friendName is %@",friendName );
    if ( friendName != nil && [friendName isKindOfClass:[NSNull class]] )
    {
        friendName = [NSString stringWithFormat:@"추천한 로티플 친구 :%@", friendName];
        [friendNameLb setText:friendName];
        [friendNameLb setHidden:NO];
        [friendDescLb setHidden:NO];
    }
    [phone2Tf setEnabled:NO];
    [phone3Tf setEnabled:NO];
    carrierBtn.enabled = NO;
}
- (void)cancelConfirm
{
    ;
}

#pragma mark - DataManagerDeleagate
- (void) didDataUpdateSuccess
{
    // 로그인 성공
    [LotipleAppAppDelegate showBusyIndicator:NO];    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) didDataUpdateFail:(NSString*)errorMsg
{
    // 로그인 실패
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [Util showAlertView:nil message:errorMsg];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
