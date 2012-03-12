//
//  ConfirmInputViewController.m
//  LotipleApp
//
//  Created by 최치선 on 11. 6. 19..
//  Copyright 2011 Home. All rights reserved.
//

#import "ConfirmInputViewController.h"

#import "LotipleAppAppDelegate.h"
#import "ServerConnection.h"
#import "RegisterViewController.h"
#import "ServerUrls.h"
#import "JSONKit.h"
#import "Util.h"

@implementation ConfirmInputViewController
@synthesize mobile, delegate;

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
    [self.navigationItem setTitle:@"휴대폰 인증" ];
    serverHelper = [[ServerHelper alloc] initWithDelegate:(NSObject<ServerOperationDelegate>*)self];
    

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

# pragma mark - Server Operation
- (void) server_confirmMobile:(NSString*)__mobile withVerifyNumber:(NSString*)verifyNum
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    [params setObject:__mobile forKey:@"mobile"];
    [params setObject:verifyNum forKey:@"verify_num"];
    NSString* url = @USER_MOBILE_VERIFY_REQUEST;
    [serverHelper sendRequestURL:url andParams:params];
}

- (void) handle_confirmMobile:(NSData*)responseData
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString *response_code = [response_all objectForKey:@"code"];
    [LotipleAppAppDelegate showBusyIndicator:NO];
    NSLog(@"response_code is %@", response_code);
    if ( [@"OK" isEqualToString:response_code ] )
    {
        NSDictionary* response_data = [response_all objectForKey:@"data"];
        NSString* friendName = [response_data objectForKey:@"friend_name"];
        [Util showAlertView:self message:@"인증 성공!"];
        [delegate successConfirm:friendName];
        UIViewController* viewPopTo = self.navigationController.topViewController;
        for (UIViewController* aView in self.navigationController.viewControllers)
        {
            if ([aView isKindOfClass:[RegisterViewController class]])
            {
                viewPopTo = aView;
            }
        }          
        [self.navigationController popToViewController:viewPopTo animated:YES];
    }
    else
    {
        NSString *response_msg = [response_all objectForKey:@"msg"];
        [Util showAlertView:nil message:response_msg];
    }
    
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSArray *chunks = [[url absoluteString ] componentsSeparatedByString:@"?"];
    [LotipleAppAppDelegate showBusyIndicator:NO];
    if ( [[chunks objectAtIndex:0] rangeOfString:@USER_MOBILE_VERIFY_REQUEST].location != NSNotFound )
    {
        [self handle_confirmMobile:responseData];
    } 
    
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"ServerOperationFail");
    [LotipleAppAppDelegate showBusyIndicator:NO];
}


# pragma mark - Handle Operation

- (IBAction)buttonClicked:(id)sender
{
    if(sender == confirmBtn)
    {
        if ( [confirmNumberTf.text length] == 0 ) 
        {
            [Util showAlertView:self message:@"인증번호를 입력해주십시오"];
            return ;
        }
        [self server_confirmMobile:mobile withVerifyNumber:confirmNumberTf.text];
    }
    else if(sender == cancelBtn)
    {
        [delegate cancelConfirm];
    }
}
- (IBAction)beginEdit:(UITextField *)sender
{
    [inputAuthNumLb setHidden:YES];
}
@end
