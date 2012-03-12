//
//  Cards.h
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


//card type =
//310 = "비씨(BC)카드"
//410 = "신한(LG)카드"
//510 = "삼성카드"
//610 = "현대카드"
//110 = "국민(KB)카드"
//710 = "롯데카드"
//210 = "외환카드"
//912 = "농협(NH)카드"
//923 = "씨티카드"
//913 = "우리카드"
//920 = "전북카드"
//610 = "신협(현대)카드"

//CardTypeHyundai,
//CardTypeKookmin,

typedef enum {
	CardTypeInvalid = -1,
	CardTypeBC,
	CardTypeShinhanLG,
	CardTypeSamsung,
    CardTypeLotte,
	CardTypeKeb,
	CardTypeNH,
	CardTypeCity,
	CardTypeWoori,
	CardTypeJeonbuk,
	CardTypeCount
} CardType;


@interface Cards : NSObject
{
    NSMutableDictionary* cardNames;
	int cardCodes[CardTypeCount];
}

+ (id)instance;

+ (NSString*)nameForType:(CardType)type;
+ (int)codeForType:(CardType)type;
+ (CardType)typeForName:(NSString*)name;
+ (int)codeForName:(NSString*)name;

@end
