//
//  Settings.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 18..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OAToken;

@interface Settings : NSObject
{
	NSString* usedId;
	NSString* usedPw;
	NSString* cardNum1;
	NSString* cardNum2;
	NSString* cardNum3;
	NSString* cardNum4;
	NSString* cardMonth;
	NSString* cardYear;
	NSString* cardType;
    NSString* tokenKey;
    NSString* tokenSecret;
    BOOL developMode;
    
}

@property (nonatomic, copy) NSString* usedId;
@property (nonatomic, copy) NSString* usedPw;
@property (nonatomic, assign) BOOL developMode;
@property BOOL saveId;
@property BOOL savePw;

@property (nonatomic, copy) NSString* cardNum1;
@property (nonatomic, copy) NSString* cardNum2;
@property (nonatomic, copy) NSString* cardNum3;
@property (nonatomic, copy) NSString* cardNum4;
@property (nonatomic, copy) NSString* cardMonth;
@property (nonatomic, copy) NSString* cardYear;
@property (nonatomic, copy) NSString* cardType, *tokenKey, *tokenSecret;


+ (id)instance;

- (void)save;
- (void)load;



@end
