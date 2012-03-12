//
//  ReplyWriteCell.h
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 31..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ReplyWriteCellDelegate <NSObject>

@optional
- (void) onCancelButtonTouched:(id)sender;
- (void) onConfirmButtonTouched:(id)sender withContent:(NSString*)contents;

@end

@interface ReplyWriteCell : UITableViewCell {

    NSObject<ReplyWriteCellDelegate> *delegate;
}

@property (nonatomic, retain) IBOutlet UITextView *commentContent;
@property (nonatomic, assign) NSObject<ReplyWriteCellDelegate> *delegate;

@end