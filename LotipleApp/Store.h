//
//  Store.h
//  LotipleApp
//
//  Created by lotiple on 11. 5. 6..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Store : NSObject {
    NSString* store_name;
	NSString* store_address;
    NSString* store_address2;
    NSString* phone;
    NSString* working_hour;
    NSString* upjong;
    NSString* imgPath;
    NSString* route_desc;
    
    int x;
    int y;
}

@property (nonatomic, retain) NSString* store_address;
@property (nonatomic, retain) NSString* store_address2;
@property (nonatomic, retain) NSString* store_name, *phone, *working_hour, *upjong, *imgPath, *route_desc;
@property (nonatomic ) int x,y;

+ (id)storeWithJSON:(NSDictionary*)json;
- (id)initWithJSON:(NSDictionary*)json;
- (id)initWithJSONData : (NSData*)jsonData;
- (id)initWithJSONDictionary: (NSDictionary*)jsonDic;
- (UIImage*)getImage;
@end
