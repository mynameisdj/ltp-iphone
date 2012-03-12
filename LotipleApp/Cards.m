//
//  Cards.m
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import "Cards.h"

#define IntKey(x) [NSNumber numberWithInt:x]

@implementation Cards


Cards* _cards;

+ (id)instance
{
	if (!_cards)
	{
		_cards = [[Cards alloc] init];
	}
	
	return _cards;
}

- (id)init
{
	self = [super init];
	if (self)
	{
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
		
		cardNames = [[NSMutableDictionary alloc] initWithCapacity:9];
		[cardNames setObject:@"비씨(BC)카드" forKey:IntKey(CardTypeBC)];
		[cardNames setObject:@"신한(LG)카드" forKey:IntKey(CardTypeShinhanLG)];
		[cardNames setObject:@"삼성카드" forKey:IntKey(CardTypeSamsung)];
	//	[cardNames setObject:@"현대카드" forKey:IntKey(CardTypeHyundai)];
//		[cardNames setObject:@"국민(KB)카드" forKey:IntKey(CardTypeKookmin)];
		[cardNames setObject:@"롯데카드" forKey:IntKey(CardTypeLotte)];
		[cardNames setObject:@"외환카드" forKey:IntKey(CardTypeKeb)];
		[cardNames setObject:@"농협(NH)카드" forKey:IntKey(CardTypeNH)];
		[cardNames setObject:@"씨티카드" forKey:IntKey(CardTypeCity)];
		[cardNames setObject:@"우리카드" forKey:IntKey(CardTypeWoori)];
		[cardNames setObject:@"전북카드" forKey:IntKey(CardTypeJeonbuk)];
//		[cardNames setObject:@"신협(현대)카드" forKey:IntKey(CardTypeShinhyup)];
		
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
		
		cardCodes[CardTypeBC] = 310;
		cardCodes[CardTypeShinhanLG] = 410;
		cardCodes[CardTypeSamsung] = 510;
	//	cardCodes[CardTypeHyundai] = 610;
	//	cardCodes[CardTypeKookmin] = 110;
		cardCodes[CardTypeLotte] = 710;
		cardCodes[CardTypeKeb] = 210;
		cardCodes[CardTypeNH] = 912;
		cardCodes[CardTypeCity] = 923;
		cardCodes[CardTypeWoori] = 913;
		cardCodes[CardTypeJeonbuk] = 920;
	//	cardCodes[CardTypeShinhyup] = 610;
	}
	
	return self;
}

- (void)dealloc
{
	[cardNames release];
	
	[super dealloc];
}

- (NSString*)nameForType:(CardType)type
{
	return [cardNames objectForKey:IntKey(type)];
}

+ (NSString*)nameForType:(CardType)type
{
	Cards* cards = [Cards instance];
	return [cards nameForType:type];
}

- (int)codeForType:(CardType)type
{
	if (type == CardTypeInvalid)
		return 0;
	
	return cardCodes[type];	
}

+ (int)codeForType:(CardType)type
{
	Cards* cards = [Cards instance];
	return [cards codeForType:type];
}

- (CardType)typeForName:(NSString*)name
{
	for (id key in cardNames)
	{
		NSString* value = [cardNames objectForKey:key];
		if ([name isEqualToString:value])
		{
			return [key intValue];
		}
	}
	
	return CardTypeInvalid;
}

+ (CardType)typeForName:(NSString*)name
{
	Cards* cards = [Cards instance];
	return [cards typeForName:name];
}

+ (int)codeForName:(NSString*)name
{
    NSLog(@"card name is %@", name);
	Cards* cards = [Cards instance];
	CardType type = [cards typeForName:name];
	return [cards codeForType:type];
}

@end
