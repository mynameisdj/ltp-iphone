//
//  Comment.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 23..
//  Copyright 2011 Home. All rights reserved.
//`

#import "Comment.h"
#import "TextUtil.h"

@implementation Comment
@synthesize content, user_id, user_nickname, deal_id, store_id, sns_type, creation_time, reply_num;
@synthesize isReply, _id;

-(id) initWithJSON:(NSDictionary*)json 
{
    self = [super init];
    self._id = [[json objectForKey:@"_id"] intValue];
    self.content = [TextUtil stringByDecodingXMLEntities:[json objectForKey:@"content" ]] ;
    self.user_nickname =[json objectForKey:@"user_nickname" ];;
    self.deal_id = [[json objectForKey:@"deal_id" ] intValue];
    self.user_id = [[json objectForKey:@"user_id" ] intValue];
    self.store_id = [[json objectForKey:@"store_id" ] intValue];
    self.sns_type = [[json objectForKey:@"sns_type" ] intValue];
    self.reply_num = [[json objectForKey:@"reply_num" ] intValue]; 

    NSTimeInterval timestamp = [[json objectForKey:@"creation_time"] doubleValue] / 1000;
	self.creation_time = [[NSDate dateWithTimeIntervalSince1970:timestamp] retain];
    self.isReply = NO;
    return self;
}


@end
