//
//  TextUtil.m
//  LotipleApp
//
//  Created by lotiple on 11. 6. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import "TextUtil.h"
#import "ServerConnection.h"
#import "OAToken.h"

@implementation TextUtil

+ (NSString *)getFormattedPrice:( int)price
{
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
    [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    NSString* formattedPrice = [[frmtr stringFromNumber:[NSNumber numberWithInt: price ]] stringByAppendingString:@"원"];
    [frmtr release];
    return formattedPrice;
}

+ (NSString *)getPhoneNum:(NSString*)phoneNum
{
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    return phoneNum;
}

+ (NSString *)getURLwithOAuthInfo:(NSString*)url
{
    ServerConnection* conn = [ServerConnection instance];
    if ( [conn logged] == NO )
    { 
        NSString* ret = [NSString stringWithFormat:@"%@%@",[conn serverUrl], url];
        return ret;
    }
    OAToken* token = [conn requestToken];
    NSString* digest = [conn sha256:[NSString stringWithFormat:@"%@%@", [token key], [token secret]]];

    NSString* ret = [NSString stringWithFormat:@"%@%@?oauth_token=%@&secret=%@", [conn serverUrl], url, [token key], digest];
    return ret;
}

+ (NSURL*)createURL:(NSString*)url withParamString:(NSString*)paramStr
{
    if ( [paramStr length] == 0 ) 
        url = [NSString stringWithFormat:@"%@", url];
    else
        url = [NSString stringWithFormat:@"%@?%@", url, paramStr];
    NSLog(@"sendURL - %@", url);
    return [[[NSURL alloc] initWithString:url] autorelease];
}


+ (NSURL*) createURL:(NSString*)url withParamDic:(NSMutableDictionary*)params
{
    NSString* paramStr = [self createParamString:params];
    return [self createURL:url withParamString:paramStr];
}

+ (NSString *)createParamString:(NSMutableDictionary*)params
{
    NSString* paramStr = @"";
    for ( id key in params )
    {
        if (![paramStr isEqualToString:@""])
			paramStr = [paramStr stringByAppendingString:@"&"];
		
		id value = [params objectForKey:key];
		paramStr = [paramStr stringByAppendingFormat:@"%@=%@", key, value];
    }
    return paramStr;
}

+ (NSString *)getCarrierCode:(NSString*)carrierName
{
    if (carrierName == nil )
        return @"";
    if ([carrierName isEqualToString:@"SKT"]) 
        return @"011";
    if ([carrierName isEqualToString:@"KTF"])
        return @"016";
    if ([carrierName isEqualToString:@"LGU+"])
        return @"019";
    return @"";
}

+ (NSString *)getTimeString:(NSDate*)aDate
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]autorelease ] ];
    if ( [self isNSDateToday:aDate] == YES) 
    {
        // 오늘인 경우 time 을 표시  
        [df setDateFormat:@"HH:mm"];
    }
    else
    {
        // 오늘 아닌경우 date 를 표시
        [df setDateFormat:@"M월d일"];
    }
    NSString* retString = nil;
    retString = [NSString stringWithFormat:@"%@", [df stringFromDate:aDate]];
    return retString;
}

+ (NSString *)getTimeStringForComment:(NSDate*)aDate
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]autorelease ] ];
    [df setDateFormat:@"yyyy.MM.dd a HH:mm"];
    NSString* retString = nil;
    retString = [NSString stringWithFormat:@"%@", [df stringFromDate:aDate]];
    return retString;
}

+ (BOOL) isNSDateToday:(NSDate*)aDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    else return NO;
}

+ (NSString *)getVerStrWithDots
{
    NSString *ver_str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return ver_str;
}



+ (NSString *)getVerStr
{
    NSString *ver_str = [self getVerStrWithDots];
    ver_str = [ver_str stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    return ver_str;
}


+ (NSString *)stringByDecodingXMLEntities:(NSString*)self_str
{
    NSUInteger myLength = [self_str length];
    NSUInteger ampIndex = [self_str rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return self_str;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:self_str];
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            if (gotNumber) {
                [result appendFormat:@"%C", charCode];
            }
            else {
                NSString *unknownEntity = @"";
                [scanner scanUpToString:@";" intoString:&unknownEntity];
                [result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
            [scanner scanString:@";" intoString:NULL];
        }
        else {
            NSString *unknownEntity = @"";
            [scanner scanUpToString:@";" intoString:&unknownEntity];
            NSString *semicolon = @"";
            [scanner scanString:@";" intoString:&semicolon];
            [result appendFormat:@"%@%@", unknownEntity, semicolon];
            NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
        }
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}
@end
