//
//  Comment.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 23..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Comment : NSObject {
    NSString* content;
    NSString* user_nickname;
    int deal_id;
    int user_id;
    int store_id;
    int _id;
    int sns_type;
    int reply_num;
    NSDate* creation_time;
    BOOL isReply;
}
@property (nonatomic, retain) NSString* content;
@property (nonatomic, retain) NSString* user_nickname;
@property (nonatomic, retain) NSDate* creation_time;
@property (nonatomic, assign) int _id, deal_id, user_id, store_id, sns_type, reply_num;
@property (nonatomic, assign) BOOL isReply;


-(id) initWithJSON:(NSDictionary*)json ;
@end
