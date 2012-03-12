//
//  MoreWebViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 25..
//  Copyright 2011 Home. All rights reserved.
//

#import "MoreWebViewController.h"
#import "TextUtil.h"


@implementation MoreWebViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithTitleText:(NSString*)__title
{
    self = [super init];
    if ( self ) 
    {
        self.title = [__title copy];
        NSLog(@" title is %@", self.title);
        [self.title retain];
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
    if (  self.title != nil && [self.title length] > 0 ) 
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"AppleGothic" size: 20.0];
        [label setMinimumFontSize:10.0];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        NSLog(@"title is %@", self.title);
        [label setText:[TextUtil stringByDecodingXMLEntities:self.title]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label sizeToFit];
        [self.navigationItem setTitleView:label];
        [label release];
    }
    

   
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
	
- (void)openUrl:(NSString*)url
{
	self.view;	// force to load
	
	NSURL* theURL = [NSURL URLWithString:url];
	NSURLRequest* requestObj = [NSURLRequest requestWithURL:theURL];
	[webView loadRequest:requestObj];
}

- (void)openImg:(NSString*)file
{	
	self.view;	// force to load

	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	NSURL *bundlePathURL = [NSURL fileURLWithPath:bundlePath];
	
	NSString* html = [NSString stringWithFormat:@"<img src='%@'>", file];
	[webView loadHTMLString:html baseURL:bundlePathURL];	
}


@end
