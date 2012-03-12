//
//  Util.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 7. 16..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {
    
}

+ (void )repositionView:(UIView*)sView andDeltaY:(float)deltaY;
+ (void )repositionView:(UIView*)sView andAbsoluteY:(float)absY;
+ (void )resizeView:(UIView*)sView width:(float)width height:(float)height;

+ (UILabel *) makeLabel:(CGRect)rect
                   text:(NSString*)text 
                  color:(UIColor*)color 
                   font:(UIFont*)font 
              textAlign:(UITextAlignment)textAlign;

+ (UIView *) lotipleButtonView:(NSString *)title target:(id)target action:(SEL)action;
+ (void) globalResignFirstResponder ;
+ (void)dismissKeyboard ;
+ (void) globalResignFirstResponderRec:(UIView*) view ;
+ (NSMutableDictionary *) loadDictionaryFromPlist: (NSString *) fileName;
+ (BOOL) saveDictionary : (NSMutableDictionary *) plistDict ToPlist: (NSString *) fileName;

+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString*)message;
+ (void)showAlertView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message title:(NSString*)title ;

+ (void)showConfirmView:(id<UIAlertViewDelegate>)delegate andTitle:(NSString*)title andMessage:(NSString *)message;
+ (void)showLoginView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message;
+ (void)showUpdateConfirmView:(id<UIAlertViewDelegate>)delegate message:(NSString *)message;



@end
