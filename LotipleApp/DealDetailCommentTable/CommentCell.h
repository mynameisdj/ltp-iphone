//
//  CommentCell.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 23..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface CommentCell : UITableViewCell {
    IBOutlet UILabel* userNameLb;
    IBOutlet UILabel* contentLb; 
    IBOutlet UILabel* dateLb;
    IBOutlet UIButton *commentButton;
    Comment* comment;
    double diffByContent;
    
    NSObject<UITableViewDelegate> *delegate;
}

@property (nonatomic, assign) double diffByContent;
@property (nonatomic, retain) IBOutlet UILabel *contentLb, *userNameLb, *dateLb;
@property (nonatomic, retain) IBOutlet UIButton *commentButton;
@property (nonatomic, assign) NSObject<UITableViewDelegate> *delegate;
- (void)setComment:(Comment*)aComment;
- (void) initBackground;
@end
