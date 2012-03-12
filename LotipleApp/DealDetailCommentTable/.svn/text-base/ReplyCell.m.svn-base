//
//  ReplyCell.m
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import "ReplyCell.h"
#import "Comment.h"
#import "TextUtil.h"

@implementation ReplyCell

@synthesize userNameLb, dateLb, contentLb;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setComment:(Comment*)aComment
{
    NSLog(@"comment why? %s",__FUNCTION__);
    userNameLb.text = [NSString stringWithFormat:@"by %@",aComment.user_nickname];
    contentLb.frame  = CGRectMake(34, 8, 235, 21);
    contentLb.text = aComment.content;
    [contentLb sizeToFit];
    dateLb.text = [TextUtil getTimeStringForComment:aComment.creation_time]; 
}

@end
