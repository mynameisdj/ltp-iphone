//
//  Util.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 7. 16..
//  Copyright 2011 Home. All rights reserved.
//

#import "Util.h"
#import "LTPConstant.h"

@implementation Util

+ (void )repositionView:(UIView*)sView andDeltaY:(float)deltaY
{
    CGRect originalFrame = sView.frame;
    originalFrame.origin.y += deltaY;
    sView.frame = originalFrame;
}

+ (void )repositionView:(UIView*)sView andAbsoluteY:(float)absY
{
    CGRect originalFrame = sView.frame;
    originalFrame.origin.y = absY;
    sView.frame = originalFrame;
}


+ (void )resizeView:(UIView*)sView width:(float)width height:(float)height;
{
    CGRect originalFrame = sView.frame;
    originalFrame.size.width += width;
    originalFrame.size.height += height;
    sView.frame = originalFrame;
}

+ (UILabel *) makeLabel:(CGRect)rect
                   text:(NSString*)text 
                  color:(UIColor*)color 
                   font:(UIFont*)font 
              textAlign:(UITextAlignment)textAlign{
    UILabel* const tmp = [[[UILabel alloc] initWithFrame:rect] autorelease];
    [tmp setText:text];
    [tmp setTextColor:color];
    [tmp setBackgroundColor:[UIColor clearColor]];
    [tmp setTextAlignment:textAlign];
    [tmp setFont:font];
    
    return tmp;
}

+ (UIView *) lotipleButtonView:(NSString *)title target:(id)target action:(SEL)action{
    UILabel *textLabel = [Util makeLabel:CGRectMake(4, 5, 0, 0) text:title color:[UIColor whiteColor] font:[UIFont fontWithName:@"AppleGothic" size:14] textAlign:UITextAlignmentLeft];
    [textLabel sizeToFit];
    UIView *viewForRight = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width+15, 28)] autorelease];
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width+10, 26)];
    [right setBackgroundImage:[[UIImage imageNamed:@"blank-square-small.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]  forState:UIControlStateNormal];
    [right setBackgroundImage:[[UIImage imageNamed:@"blank-square-small-touch.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]  forState:UIControlStateHighlighted];
    [right setShowsTouchWhenHighlighted:NO];
    [right addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    [viewForRight addSubview:right];
    [right addSubview:textLabel];
    [right release];

    return viewForRight;
}

+ (void)dismissKeyboard {
    [self globalResignFirstResponder];
}

+ (void) globalResignFirstResponder {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    for (UIView * view in [window subviews]){
        [self globalResignFirstResponderRec:view];
    }
}

+ (void) globalResignFirstResponderRec:(UIView*) view {
    if ([view respondsToSelector:@selector(resignFirstResponder)]){
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]){
        [self globalResignFirstResponderRec:subview];
    }
}

+ (NSString *) documentDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
	return documentDir;
}

+ (NSMutableDictionary *) loadDictionaryFromPlist: (NSString *) fileName {
	NSString *documentDir = [Util documentDirectoryPath];
	NSString *path = [documentDir stringByAppendingPathComponent:fileName];
	NSMutableDictionary* plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	
	if (plistDict == nil) {
		plistDict = [NSMutableDictionary dictionary];
	}
	
	return plistDict;
}

+ (BOOL) saveDictionary : (NSMutableDictionary *) plistDict ToPlist: (NSString *) fileName{
	NSString *documentDir = [Util documentDirectoryPath];
	NSString *path = [documentDir stringByAppendingPathComponent:fileName];
	return [plistDict writeToFile:path atomically: YES];
}



+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString*)message
{
    if (message == nil)
        return;
    [self showAlertView:delegate message:message title:@"확인"];
}

+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title 
{
    if ( message == nil || [message isKindOfClass:[NSNull class]] ) 
        return ;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"확인"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (void)showConfirmView:(id<UIAlertViewDelegate>)delegate andTitle:(NSString*)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:title];
	[alert setMessage:message];
	[alert setDelegate:delegate];
	[alert addButtonWithTitle:@"취소"];
	[alert addButtonWithTitle:@"확인"];
	[alert show];
	[alert release];
}

+ (void)showLoginView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message 
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@LOGIN_ALERT_LABEL];
	[alert setMessage:message];
	[alert setDelegate:delegate];
	[alert addButtonWithTitle:@"취소"];
	[alert addButtonWithTitle:@"로그인/가입"];
	[alert show];
	[alert release];
}


+ (void)showUpdateConfirmView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@UPDATE_ALERT_LABEL];
	[alert setMessage:message];
	[alert setDelegate:delegate];
	[alert addButtonWithTitle:@"취소"];
	[alert addButtonWithTitle:@"업데이트"];
	[alert show];
	[alert release];
}



@end
