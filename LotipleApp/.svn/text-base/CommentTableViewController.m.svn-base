//
//  CommentTableViewController.m
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 31..
//  Copyright 2011 Home. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentCell.h"
#import "ReplyCell.h"
#import "Comment.h"
#import "LotipleAppAppDelegate.h"
#import "TextUtil.h"
#import "Util.h"
#import "NSString+URLEncoding.h"
#import "ServerUrls.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "ServerConnection.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_MARGIN 8.0f

@interface CommentTableViewController (privates)
- (CGFloat)heightForCommentText:(NSString *)text;
- (CGFloat)heightForReplyText:(NSString *)text;
- (void) relocateWriteReplyCell:(NSIndexPath *)indexPath;
- (void) hideWriteReplyCell;
- (Comment *)commentByIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) numberOfReplyForComment:(Comment *)comment;
@end

@implementation CommentTableViewController

@synthesize commentList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.commentList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commentList = [NSMutableArray array];
    rowForReplyWriteCell = -1;
    serverHelper = [[ServerHelper alloc] initWithDelegate:(NSObject<ServerOperationDelegate>*)self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    hasReplyWriteCell = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) handle_commentWrite :(NSData*)responseData
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    NSDictionary *response_all = [[JSONDecoder decoder] objectWithData:responseData];
    NSString *response_code = [response_all objectForKey:@"code"];
    if ( [@"OK" isEqualToString:response_code] )
    {
        [self onSuccessWriteReply];
    }
    else
    {
        NSString* response_msg = [response_all objectForKey:@"msg"];
        [Util showAlertView:nil message:response_msg];
    }
}


#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@COMMENT_WRITE_REQUEST].location != NSNotFound )
    {
        [self handle_commentWrite:responseData];
    }

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self.commentList count] == 0 )
        return 55;
    
    if ( hasReplyWriteCell && indexPath.row == rowForReplyWriteCell ) {
        return 148.0;
    }
    
    Comment* comment = [self commentByIndexPath:indexPath];    
    
    NSString* text = [comment content];
    if ( !comment.isReply )
        return [self heightForCommentText:text];
    else 
        return [self heightForReplyText:text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([commentList count] == 0 )
        return 1;
    if ( hasReplyWriteCell )
        return [commentList count] + 1;
    return [commentList count];
}

- (float)textViewPositionInCommentTable {
    float commentTableHeightSum = 0;
    for ( int i = 0 ; i < rowForReplyWriteCell ; ++i)
    {
        Comment *comment = [self.commentList objectAtIndex:i];
        NSString *text = [TextUtil stringByDecodingXMLEntities:[comment content]];
        if (comment.isReply)
            commentTableHeightSum += [self heightForReplyText:text] +1;
        else 
            commentTableHeightSum += [self heightForCommentText:text] + 1;
    }

    return commentTableHeightSum + 10;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReplyEditingStarted"  object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:self.view.frame.origin.y + [self textViewPositionInCommentTable]] forKey:@"y"] ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [commentList count] == 0 ){
        static NSString* CellIdentifier = @"NoCell";
        CommentCell *cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) 
        {
            NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"CommentCells" owner:self options:nil];
            cell = (CommentCell*)[objects objectAtIndex:0];
            [cell initBackground];
            
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"낙서가 없네요. 하나 써주시겠습니까?";
        }
        return cell;
    }
    
    UITableViewCell *rCell;
    if ( hasReplyWriteCell && indexPath.row == rowForReplyWriteCell ) {
        ReplyWriteCell* cell = nil;
        static NSString* CommentCellIdentifier = @"ReplyWriteCell";
        cell = (ReplyWriteCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        if (!cell)
        {
            NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"ReplyWriteCell" owner:self options:nil];
            cell = (ReplyWriteCell*)[objects objectAtIndex:0];
            objects = nil;
        }
        [cell setDelegate:self];
        presentView = [cell.commentContent retain];
        cell.commentContent.delegate = self;
        rCell = cell;
        
        return rCell;
    }
    
    Comment* comment = [self commentByIndexPath:indexPath];    

    if ( ! comment.isReply ) {
        CommentCell* cell = nil;
        static NSString* CommentCellIdentifier = @"CommentCell";
        cell = (CommentCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        if (!cell)
        {
            NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"CommentCells" owner:self options:nil];
            cell = (CommentCell*)[objects objectAtIndex:0];
            [cell initBackground];
            objects = nil;
        }
        cell.textLabel.text = @"";
        [cell setComment:comment];
        
        float ret = [self heightForCommentText:comment.content];
        cell.userNameLb.frame = CGRectMake(124 ,ret-59, 100, 30);
        cell.dateLb.frame = CGRectMake(8,ret-58, 146, 30);
        cell.commentButton.frame = CGRectMake(8, ret-30, 51, 23);
        
        int cnt = [self numberOfReplyForComment:comment];
        [cell.commentButton setTitle:[NSString stringWithFormat:@"%d", cnt] forState:UIControlStateNormal];    
        
        rCell = cell;
    }
    else {
        NSLog(@"%s it is Reply",__FUNCTION__);
        static NSString* replyCellIdentifier = @"ReplyCell";
        ReplyCell* cell = nil;
        cell = (ReplyCell*)[tableView dequeueReusableCellWithIdentifier:replyCellIdentifier];
        if (!cell)
        {
            NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"ReplyCell" owner:self options:nil];
            cell = (ReplyCell*)[objects objectAtIndex:0];
            objects = nil;
        }
        cell.textLabel.text = @"";
        [cell setComment:comment];
        
        float ret = [self heightForReplyText:comment.content];
        cell.userNameLb.frame = CGRectMake(155 ,ret-29, 100, 30);
        cell.dateLb.frame = CGRectMake(35,ret-28, 146, 30);
        
        rCell = cell;
    }
    
    return rCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ;
}

#pragma mark - Comment Util

- (CGFloat)heightByUILabelText:(NSString *)text width:(CGFloat) width {
    UILabel* commentLb = [[UILabel alloc] init];
    CGRect frame = CGRectMake(0.f, 0.f, width, 35.f);
    commentLb.font = [UIFont fontWithName:@"Helvetica" size: 13.0f];
    commentLb.frame = frame;
    commentLb.lineBreakMode = UILineBreakModeCharacterWrap;
    commentLb.numberOfLines = 0;
    commentLb.text = text;
    commentLb.autoresizingMask = UIViewAutoresizingNone;
    [commentLb sizeToFit];
    
    CGFloat height = MAX(commentLb.frame.size.height, 25.f) + CELL_CONTENT_MARGIN*2;
    [commentLb release];
    return height;
}

- (CGFloat)heightForCommentText:(NSString *)text
{
    return [self heightByUILabelText:text width:280] + 40;
}

- (CGFloat)heightForReplyText:(NSString *)text
{
    return [self heightByUILabelText:text width:235] + 10 ;
}

#pragma mark - update comment list

- (void)initCommentList:(NSDictionary*)commentDic
{
    NSDictionary* response_data = [commentDic objectForKey:@"data"];
    NSArray* comment_list = [response_data objectForKey:@"comment_list"];
    int count = [comment_list count];
    commentList = [[NSMutableArray alloc] init];
    for ( int i = 0 ; i < count ; i++)
    {
        NSDictionary *commentJSONData = [comment_list objectAtIndex:i];
        Comment *newComment = [[Comment alloc] initWithJSON:commentJSONData];
        [commentList addObject:newComment];
        if ( [newComment reply_num ] > 0 ) {
            ///////////// 여기서부터 한줄낙서의 댓글 처리 ////begins/////
            NSArray* reply_list = [commentJSONData objectForKey:@"reply_list"];
            for (  NSDictionary *replyDict in reply_list ) {
                Comment *newReply = [[Comment alloc] initWithJSON:replyDict];
                newReply.isReply = YES;
                [commentList addObject:newReply];
                [newReply release];
            }
            //////////// 한줄낙서 댓글 처리 /////////////ends ////////
        }
        [newComment release];
    }
}

- (float)getCommentTableHeightSum {
    float commentTableHeightSum = 0;
    for ( Comment *comment in commentList)
    {
        NSString *text = [TextUtil stringByDecodingXMLEntities:[comment content]];
        if (comment.isReply)
            commentTableHeightSum += [self heightForReplyText:text] +1;
        else 
            commentTableHeightSum += [self heightForCommentText:text] + 1;
    }
    if ( [commentList count] ==0 )  commentTableHeightSum +=70;

    if ( hasReplyWriteCell ) {
        commentTableHeightSum += 150;
    }
    return commentTableHeightSum;
}

- (void)setCommentListUI:(NSDictionary*)commentDic
{
    hasReplyWriteCell = NO;
    [self initCommentList:commentDic];
}

#pragma mark - Server Operation
- (void)server_writeReply:(NSString*)contents
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
    NSLog(@"original_id is %d", original_id);
    [params setObject:[NSString stringWithFormat:@"%d", original_id] forKey:@"original_id"];
    [params setObject:[contents URLEncodedString] forKey:@"content"];
    NSString* url = @COMMENT_WRITE_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
    
}

#pragma mark - Comment Write Cell

- (IBAction)onReplyWriteButtonClicked:(id)sender event:(id)event {
    
    if ( [[ServerConnection instance] logged] == NO ) {
        [Util showAlertView:nil message:@"로그인해야 댓글작성이 가능합니다."];
        return;
    }
    NSLog(@"%s",__FUNCTION__);
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
        if (presentView !=nil )
            [presentView resignFirstResponder];
        NSLog(@"%s %d", __FUNCTION__, indexPath.row);
        Comment* comment = [self commentByIndexPath:indexPath];    
        original_id = comment._id;
        BOOL notReply = ! comment.isReply;
        BOOL notReplyWriteCell = (indexPath.row != rowForReplyWriteCell);
        BOOL notSame = ( indexPath.row != rowForReplyWriteCell -1 );
        if ( notReply && notReplyWriteCell && notSame ) {
            [self relocateWriteReplyCell:indexPath];
        }
	}
}


- (void) onCancelButtonTouched:(id)sender {
    [self hideWriteReplyCell];
}

- (void) onConfirmButtonTouched:(id)sender withContent:(NSString *)contents {
    // try to write reply
    [self server_writeReply:contents];
}

- (void) onSuccessWriteReply { 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentListUpdated"  object:nil ];
    [self hideWriteReplyCell];
}

- (void) hideWriteReplyCell {
    [self.tableView beginUpdates];
    hasReplyWriteCell = NO;
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowForReplyWriteCell inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    if ( rowForReplyWriteCell < [self.commentList count] ) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowForReplyWriteCell inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }

    rowForReplyWriteCell = -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentTableHeightChanged"  object:nil ];
}

- (void) relocateWriteReplyCell:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    if ( hasReplyWriteCell ) {
        int minRow = ( rowForReplyWriteCell > indexPath.row) ? indexPath.row : rowForReplyWriteCell ; 
        int maxRow = (( rowForReplyWriteCell < indexPath.row) ?  indexPath.row : rowForReplyWriteCell ); 
        if ( maxRow < [commentList count] ) maxRow++;
        if ( minRow > 0 ) minRow--;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity: maxRow - minRow + 1];
        for ( int i = minRow ; i<=maxRow ; ++i) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:indexPaths  withRowAnimation:UITableViewRowAnimationNone];
        
        if ( indexPath.row > rowForReplyWriteCell )
            rowForReplyWriteCell = indexPath.row;
        else 
            rowForReplyWriteCell = indexPath.row+1;

    } else {
        hasReplyWriteCell = YES;
        rowForReplyWriteCell = indexPath.row+1;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowForReplyWriteCell inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentTableHeightChanged"  object:nil ];
}

#pragma mark - accessory

- (Comment *)commentByIndexPath:(NSIndexPath *)indexPath {
    Comment * comment;
    if ( hasReplyWriteCell ) {
        if ( indexPath.row > rowForReplyWriteCell ) {
            comment = [self.commentList objectAtIndex:indexPath.row-1];
        } else {
            comment = [self.commentList objectAtIndex:indexPath.row];
        }
    } else {
        comment  = [self.commentList objectAtIndex:indexPath.row];
    }       
    return comment;
}

- (NSInteger) numberOfReplyForComment:(Comment *)comment {
    int idx = [self.commentList indexOfObject:comment];
    int cnt = 0;
    for ( int i = idx+1; i < [self.commentList count] ; ++i)
    {
        Comment *elem = [self.commentList objectAtIndex:i];
        if ( elem.isReply )
            cnt ++;
        else 
            break;
    }
    return cnt;
}

@end
