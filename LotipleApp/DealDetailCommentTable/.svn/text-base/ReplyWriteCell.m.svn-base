//
//  CommentWriteCell.m
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 31..
//  Copyright 2011 Home. All rights reserved.
//

#import "ReplyWriteCell.h"


@implementation ReplyWriteCell

@synthesize commentContent;
@synthesize delegate;

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

- (IBAction) onCancelBtn : (id)sender {
    [commentContent resignFirstResponder];
    if ( [delegate respondsToSelector:@selector(onCancelButtonTouched:)] ) {
        [delegate onCancelButtonTouched:sender];
    }
}


- (IBAction) onConfirmBtn : (id)sender {
    [commentContent resignFirstResponder];
    if ( [delegate respondsToSelector:@selector(onConfirmButtonTouched:withContent:)] ) {
        NSString* content = [NSString stringWithString:commentContent.text];
        [delegate onConfirmButtonTouched:sender withContent:content];
        commentContent.text = @"";
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
