//
//  WriteCommentViewController.m
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 6. 24..
//  Copyright 2011 Home. All rights reserved.
//

#import "WriteCommentViewController.h"
#import "ServerConnection.h"
#import "LotipleAppAppDelegate.h"
#import "NSString+URLEncoding.h"
#import "ServerUrls.h"
#import "Util.h"

@implementation WriteCommentViewController

@synthesize deal_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    commentTextView.text = @"";
    [commentTextView becomeFirstResponder];
}

#pragma mark - Server Operation

- (void)server_writeComment:(NSString *)commentContent
{
    [LotipleAppAppDelegate showBusyIndicator:YES];
    NSMutableDictionary* params = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
    [params setObject:[NSString stringWithFormat:@"%d", deal_id] forKey:@"deal_id"];
    [params setObject:[commentContent URLEncodedString] forKey:@"content"];
    NSString* url = @COMMENT_WRITE_REQUEST;
    [serverHelper sendOAuthRequestURL:url andParams:params];
}

#pragma mark - Handle Operation
- (void)handle_writeComment
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeButtonClicked {
    NSString* content = commentTextView.text ;
    NSString *trimmedString = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( [trimmedString length] == 0 ) 
    {
        //TODO 0글자 올리는 경우는 막아야함 ;
        [Util showAlertView:self message:@"낙서는 1글자 이상이어야 합니다." ];
    }
    else {
        [self server_writeComment:content];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    serverHelper = [[ServerHelper alloc] initWithDelegate:(NSObject<ServerOperationDelegate>*)self];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* writeButton;
    writeButton = [[UIBarButtonItem alloc] initWithTitle:@"올리기"
                                               style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(writeButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = writeButton;
    [writeButton release];
    self.title = @"한줄 낙서";
    commentTextView.delegate = self;
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - TextView changes
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%s",__FUNCTION__);
    textCountLb.text = [NSString stringWithFormat:@"%d / 140", [textView.text length]];
}
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.length > text.length){
        return YES;
    }else if([[textView text] length] + text.length > 140){
        return NO;
    }
    return YES;
}

#pragma mark - ServerOperationDelegate
-(void)didServerOperationSuccess:(NSData*)responseData andURL:(NSURL*)url
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    NSArray *chunks = [[url absoluteString] componentsSeparatedByString: @"?" ];
    if ( [[chunks objectAtIndex:0] rangeOfString:@COMMENT_WRITE_REQUEST].location != NSNotFound )
    {
        NSLog(@"ServerInfo");
        [self handle_writeComment];
    }
}

- (void) didServerOperationFail:(NSURL*)url andErrorMsg:(NSString*)errMsg
{
    NSLog(@"ServerOperationFail");
    [LotipleAppAppDelegate showBusyIndicator:NO];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ;
}

@end
