//
//  WhatIsLotipleViewController.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 12..
//  Copyright 2011 Home. All rights reserved.
//

#import "WhatIsLotipleViewController.h"
const CGFloat kScrollObjHeight	= 186.0;
const CGFloat kScrollObjWidth	= 302.0;
const int kNumImages = 5;

@implementation WhatIsLotipleViewController

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
    [images release];
    [imagesSv release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [imagesSv subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[imagesSv setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [imagesSv bounds].size.height)];
}

- (void)setHowtoImages
{
    // 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[imagesSv setBackgroundColor:[UIColor whiteColor]];
	[imagesSv setCanCancelContentTouches:NO];
	imagesSv.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	imagesSv.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
    imagesSv.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	imagesSv.pagingEnabled = YES;
    int cnt = 1 ;
    for ( UIImage* image in images )
    {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		imageView.tag = cnt++;	// tag our images for later use when we place them in serial fashion
		[imagesSv addSubview:imageView];
		[imageView release];
    }
    [self layoutScrollImages];
    
 
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    NSLog(@"%@", __FUNCTION__);
    if (pageControlIsChangingPage)
	{
		return;
	}
	
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	imagesPc.currentPage = page;
	
//	[_view scrollRectToVisible:imagesSv.frame animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    NSLog(@"%@", __FUNCTION__);
    pageControlIsChangingPage = NO;
}

#pragma mark - Event handlers

- (IBAction)pageChanged:(id)sender 
{
    NSLog(@"%@", __FUNCTION__);
	CGRect frame = imagesSv.frame;
	frame.origin.x = frame.size.width * imagesPc.currentPage;
	frame.origin.y = 0;
    
	[imagesSv scrollRectToVisible:frame animated:YES];
    
	pageControlIsChangingPage = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"how1.png"],[UIImage imageNamed:@"how2.png"],[UIImage imageNamed:@"how3.png"], [UIImage imageNamed:@"how4.png"], [UIImage imageNamed:@"how5.png"],nil];
    [self setHowtoImages];
    // Do any additional setup after loading the view from its nib.
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


@end
