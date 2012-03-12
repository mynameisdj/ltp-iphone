//
//  CommentCell.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 23..
//  Copyright 2011 Home. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "TextUtil.h"


@implementation CommentCell

@synthesize diffByContent , contentLb;
@synthesize userNameLb, dateLb, commentButton;
@synthesize delegate;

#pragma mark - default cell method
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

- (IBAction) onCommentButton:(id)sender {

}

- (void) initBackground {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor darkGrayColor];
    self.selectedBackgroundView = v;
    [v release];   
    
    UIImage *sImage = [((UIImageView *) self.backgroundView).image stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    ((UIImageView *) self.backgroundView).image = sImage;
}

#pragma mark - misc
- (void)setComment:(Comment*)aComment
{
    userNameLb.text = [NSString stringWithFormat:@"by %@",aComment.user_nickname];
    contentLb.frame  = CGRectMake(8, 8, 278, 21);
    contentLb.text = aComment.content;
    [contentLb sizeToFit];
    dateLb.text = [TextUtil getTimeStringForComment:aComment.creation_time]; 
}

@end
