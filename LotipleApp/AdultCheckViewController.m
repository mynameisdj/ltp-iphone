//
//  AdultCheckViewController.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 9. 7..
//  Copyright 2011 Home. All rights reserved.
//

#import "AdultCheckViewController.h"
#import "ServerUrls.h"
#import "LotipleAppAppDelegate.h"
#import "JSONKit.h"
#import "AdultCheckDelegate.h"
#import "Util.h"


@implementation AdultCheckViewController
@synthesize delegate;

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

#pragma mark - Outgoing Operation
- (void)server_adultCheck:(NSMutableDictionary*)params;
{
    NSString* url = @USER_ADULT_CHECK_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
}

- (void)handle_adultCheckOK:(NSData*)responseData
{
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString* response_code = [response_all objectForKey:@"code"];
    NSLog(@" response_code is Equal to %@", response_code );
    if ( [@"OK" isEqualToString:response_code ] )
    {
        NSString* okmsg = @"실명인증성공";
        [Util showAlertView:nil message:okmsg];
        if ( [delegate respondsToSelector:@selector(didAdultCheckSuccess)]) {
            [delegate didAdultCheckSuccess];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        NSString* response_msg = [response_all objectForKey:@"msg"];
        [Util showAlertView:nil message:response_msg];

    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

// TODO : to be implemented 

- (BOOL)isAdultCheckOK
{
    return YES;
}
#pragma mark - UITextField
- (IBAction)editingChanged:(id)sender;
{
    UITextField* textField = (UITextField*)sender;
	
	// 뭐..이런건 그냥 하드코딩이 진리
	NSUInteger length = [textField.text length];

    if (length == 6 && textField == ssn1Tf)
    {
        [ssn2Tf becomeFirstResponder];
    }
}


#pragma mark - Event handlers

- (IBAction)buttonClicked:(id)sender
{
	if (sender == okBtn)
	{
        if ( [self isAdultCheckOK] == YES) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
            [params setObject:nameTf.text forKey:@"name"];
            [params setObject:ssn1Tf.text forKey:@"ssn1"];
            [params setObject:ssn2Tf.text forKey:@"ssn2"];
            [self server_adultCheck:params];
        }
	}
    if ( sender == cancelBtn )
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url 
{
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@USER_ADULT_CHECK_REQUEST].location != NSNotFound )
    {
        [self handle_adultCheckOK:responseData];
    }
}

@end
