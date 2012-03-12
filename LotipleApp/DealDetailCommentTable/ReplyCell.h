//
//  ReplyCell.h
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface ReplyCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UILabel *contentLb, *userNameLb, *dateLb;
- (void)setComment:(Comment*)aComment;

@end
