//
//  CommentTableViewController.h
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 31..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyWriteCell.h"
#import "ServerHelper.h"

@interface CommentTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, ReplyWriteCellDelegate, UITextViewDelegate> {
    NSMutableArray *commentList;
    
    BOOL hasReplyWriteCell;
    int rowForReplyWriteCell;
    UITextView *presentView;
    ReplyWriteCell *replyWriteCell;
    ServerHelper *serverHelper;
    int original_id;
}

@property (nonatomic, retain) NSMutableArray *commentList;

- (void)setCommentListUI:(NSDictionary*)commentDic;
- (float)getCommentTableHeightSum;
- (void)server_writeReply:(NSString*)contents;
- (void)onSuccessWriteReply;

@end
