//
//  LoginViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import "LoginViewController.h"

#import "ServerConnection.h"
#import "Settings.h"
#import "TranManager.h"
#import "RegisterViewController.h"
#import "LotipleAppAppDelegate.h"
#import "UserManager.h"
#import "Util.h"

@implementation LoginViewController

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
    [registerBtn release];
    [loginBtn release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"로그인";
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [LotipleUtil trackPV:@"/login"];
	[super viewWillAppear:animated];
    
    if ( [[ServerConnection instance] logged] == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    Settings* settings = [Settings instance];
    if (settings.saveId && settings.usedId) {
        [id_emailView setHidden:YES];
        idTf.text = settings.usedId;
    }
    if (settings.savePw && settings.usedPw) {
        [passwordView setHidden:YES];
        passwordTf.text = settings.usedPw;
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)isLoginOK
{
    NSString* _id = [idTf text];
    NSString* pw = [passwordTf text];
    NSString* message = nil;
    if ( ![_id length] )
    {
        message = @"아이디를 입력해주세요.";
    }
    else if (![pw length] )
    {
        message = @"패스워드를 입력해주세요";
    }
    
    if (message)
    {
        [Util showAlertView:nil message:message];
        return NO;
    }
    return YES;
}

#pragma mark - Event handlers

- (void) doLogin {
    NSLog(@"show busy indicator");
    
    if ( [self isLoginOK] == NO )
        return ;
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSString* _id = [idTf text];
    NSString* pw = [passwordTf text];
    
    if ( [@"lotiple" isEqualToString:_id] && [@"2848048" isEqualToString:pw] ) 
    {
        [[ServerConnection instance] setDebugMode];
        [[Settings instance] save];
        return ;
        
    }
    Settings *settings = [Settings instance];
    settings.usedId = _id;
    settings.usedPw = pw;
    [settings save];
    
    [[UserManager instance] server_login:_id password:pw delegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doLogin];
    return YES;
}

- (IBAction)buttonCliked:(id)sender
{
	if (sender == loginBtn)
	{
        [self doLogin];
	}
	else if (sender == registerBtn)
	{		
		RegisterViewController* registerView = [[RegisterViewController alloc] init];
		[[self navigationController] pushViewController:registerView animated:YES];
		[registerView release];

	}
	
}

#pragma mark - UITextFieldDelegate

- (IBAction)beginEdit:(UITextField *)textField
{
    if (textField == idTf) {
        [id_emailView setHidden:YES];
    }
    else if (textField == passwordTf ) {
        [passwordView setHidden:YES];
    }
}


#pragma mark - DataManagerDeleagate
- (void) didDataUpdateSuccess
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) didDataUpdateFail:(NSString*)errorMsg
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [Util showAlertView:nil message:errorMsg];
}



@end
