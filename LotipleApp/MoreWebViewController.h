//
//  MoreWebViewController.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 25..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreWebViewController : UIViewController
{
	IBOutlet UIWebView* webView;
    NSString* title;
}

- (void)openUrl:(NSString*)url;
- (void)openImg:(NSString*)file;
- (id)initWithTitleText:(NSString*)__title;

@property (nonatomic, retain) UIWebView *webView;

@end
