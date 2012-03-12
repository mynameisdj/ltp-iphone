//
//  PurchaseWebViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 5. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import "PurchaseWebViewController.h"

#import "LotipleAppAppDelegate.h"
#import "ServerConnection.h"
#import "DetailViewController.h"
#import "TranManager.h"
#import "Util.h"

@implementation PurchaseWebViewController

@synthesize purchaseWebView;
@synthesize isAppear, request;

- (id)initWithRequest:(NSMutableURLRequest*)_request
{
    self = [super init];
    if ( self )
    {
        [self setRequest:_request];
        [[self purchaseWebView] setDelegate: self]; 
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
    NSLog(@"%s:%s request:%@",__FILE__, __FUNCTION__ , self.request );
    // Do any additional setup after loading the view from its nib.	
    isAppear = NO;
    [purchaseWebView loadRequest:self.request];

}

- (void)viewDidUnloadf
{
    NSLog(@"viewDidUnLoad");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [purchaseWebView stopLoading];
    [super viewWillDisappear:animated];
    isAppear = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
   
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s viewDidFinishLoad",__FUNCTION__);
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [LotipleAppAppDelegate showBusyIndicator:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s viewDidStartLoad",__FUNCTION__);
    [LotipleAppAppDelegate showBusyIndicator:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didfailloadwitherror");
    NSString *errStr = [error localizedDescription];
    NSString *message = [NSString stringWithFormat:@"서버연결에 문제가 있습니다. %@", errStr];
    NSLog(@"%@",message);
    [LotipleAppAppDelegate showBusyIndicator:NO];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *requestString = [[_request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    NSLog(@"[%d] %@", navigationType, [[_request URL] absoluteString]);
    
    
    if ( [requestString rangeOfString:@"paygate.net/ajax/"].location != NSNotFound ) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:requestString]];
        return NO;
    }
    
    if ( [requestString rangeOfString:@"hd_stip.jsp"].location != NSNotFound ) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:requestString]];
        return NO;
    }
            
	if ([components count] >= 2)
	{
		NSString* class = (NSString*)[components objectAtIndex:0];
		NSString* method = (NSString*)[components objectAtIndex:1];
		
		if ([class isEqualToString:@"lotipleapp"])
		{
			if ([method isEqualToString:@"paymentSuccess"])
			{
                
                // TODO: transaction 에 대한 local caching 
                // 다시말해, 구매가 정상적으로 이루어졌다는 증거 이 사이에 인터넷이 끊겨도 다시 시도 하면 인정해줌. 
                
                
                
				// 이걸 호출하면 setTransactionId 가 다시 온다고 함 ( transcation validation )
				NSString *jsCommand = @"getTransactionId();";
				[purchaseWebView stringByEvaluatingJavaScriptFromString:jsCommand];
                
                // getTransactionId 가 성공하면 local cache 삭제 
                // 실패하면 갖고 있고.. alert 를 띄워서 다시 시도하게 한다. 
                
                
			}
			
			if ([method isEqualToString:@"paymentFail"])
			{
				NSString* message = @"구매에 실패했습니다.";
				[Util showAlertView:nil message:message];
				
				[self.navigationController popViewControllerAnimated:YES];
			}

			if ([method isEqualToString:@"setTransactionId"])
			{
				NSString* param1 = (NSString*)[components objectAtIndex:2];				
				[[ServerConnection instance] submitTransaction:[param1 intValue]];
				
				NSString* message = @"구매가 성공하였습니다";
				[Util showAlertView:nil message:message];

				// 디테일 뷰를 찾아서 글로 포커스를 보낸다
				UIViewController* viewPopTo = self.navigationController.topViewController;
				for (UIViewController* aView in self.navigationController.viewControllers)
				{
					if ([aView isKindOfClass:[DetailViewController class]])
					{
						viewPopTo = aView;
					}
				}                
				[self.navigationController popToViewController:viewPopTo animated:YES];
			}

			return NO;
		}
        
        // bc 카드의 경우 전용 어플을 깔아야 함 
        if ( [class isEqualToString:@"itms-apps"] ) 
        {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:requestString]];
            return NO;
        }
	}
	
	return YES; // Return YES to make sure regular navigation works as expected
}


@end


@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{	
    NSLog(@"javascript alert : %@",message);
	UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];	
    [customAlert show];
    [customAlert release];
}

@end