//
//  PurchaseWebViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 5. 2..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PurchaseWebViewController : UIViewController <UIAlertViewDelegate, UIWebViewDelegate>
{
	IBOutlet UIWebView* purchaseWebView;
    BOOL isAppear;
}

- (id)initWithRequest:(NSMutableURLRequest*)request;

@property (nonatomic, retain) UIWebView* purchaseWebView;
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, retain) NSMutableURLRequest* request;

@end

@interface UIWebView (JavaScriptAlert) 

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

@end