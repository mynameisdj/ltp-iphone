//
//  MoreViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 13..
//  Copyright 2011 Home. All rights reserved.
//

#import "MoreViewController.h"
#import "WhatIsLotipleViewController.h"

#import "LoginViewController.h"
#import "MoreWebViewController.h"
#import "CreditCardViewController.h"
#import "RegisterViewController.h"
#import "LotipleAppAppDelegate.h"

#import "ServerConnection.h"
#import "TextUtil.h"
#import "Util.h"
#import "UserManager.h"
#import "MoreViewCell.h"
#import "LTPConstant.h"

@interface MoreViewController (private)

- (void) setupNavigationItem;
@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithTitleText:(NSString*)__title
{
    self = [super init];
    if ( self ) 
    {
        self.title = __title;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


#pragma navigation Buttons

- (void) setRegisterButton {
    UIView *viewForLeft = [Util lotipleButtonView:@"회원가입" target:self action:@selector(moreViewRegister)];
        
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:viewForLeft];
    [self.navigationItem setLeftBarButtonItem:leftBtn animated:YES];
    [leftBtn release];
}

- (void) setLoggedButton {
    BOOL is_login = [[ServerConnection instance] logged];
    UIView *viewForRight;
    if ( !is_login ) {
        viewForRight = [Util lotipleButtonView:@"로그인" target:self action:@selector(moreViewLogin)];
        [self setRegisterButton];
    }
    else {
        viewForRight = [Util lotipleButtonView:@"로그아웃" target:self action:@selector(moreViewLogout)];
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    UIBarButtonItem* rightBtn;
    rightBtn = [[UIBarButtonItem alloc] initWithCustomView:viewForRight];
    [self.navigationItem setRightBarButtonItem:rightBtn animated:YES];
    [rightBtn release];
}

- (void) moreViewLogin {
    LoginViewController* loginView = [[LoginViewController alloc] init];
    loginView.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:loginView animated:YES];
    [loginView release];
}

- (void) moreViewLogout {
    [[UserManager instance] logout];
    [self setupNavigationItem];
}

- (void) moreViewRegister {
    RegisterViewController* registerView = [[RegisterViewController alloc] init];
    registerView.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:registerView animated:YES];
    [registerView release];
}

- (void) setupNavigationItem {
    [self setLoggedButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)viewWillAppear:(BOOL)animated
{
    [self setupNavigationItem];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) showTabbar];
	[menuTv reloadData];
    menuTv.separatorColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1];
	
	[super viewWillAppear:animated];
    
    
    [LotipleUtil trackPV:@"/more"];
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section)
	{
		case 0:
			return @"로티플";
		case 1:
            return @"문의사항";
		case 2:
			return @"약관";
	}

    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
            if ( [[ServerConnection instance] eventMode] == YES) {
                return 4;
            }
            else
                return 3;
		case 1:
            return 2;
        case 2:
            return 3;
	}
	return 0;
}

- (void) cellContent:(UITableViewCell *)cell ForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 7.0, 200.0, 30.0)];
    [textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    textLabel.frame = CGRectMake(30.0, 4.0, 200.0, 30.0);

    
    
    [[cell contentView] addSubview:textLabel];
    [textLabel release];
}

static NSArray *cellBackgroundList;
static BOOL backgroundLoaded = NO;
enum {
    CELL_ONE,
    CELL_TOP,
    CELL_MIDDLE,
    CELL_BOTTOM,
    CELL_ONE_GRAY,
    CELL_TOP_GRAY,
    CELL_MIDDLE_GRAY,
    CELL_BOTTOM_GRAY
} cell_index;
- (void) cellBackGround:(UITableViewCell *)cell ForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !backgroundLoaded ) {
        cellBackgroundList  = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"whiteDownBar.png"],
                               [UIImage imageNamed:@"whiteUpBar.png"],
                               [UIImage imageNamed:@"whiteMidBar.png"],
                               [UIImage imageNamed:@"whiteDownBar.png"],
                               [UIImage imageNamed:@"grayUpBar.png"],
                               [UIImage imageNamed:@"grayUpBar.png"],
                               [UIImage imageNamed:@"grayMidBar.png"],
                               [UIImage imageNamed:@"grayDownBar.png"],nil];
    }
    
    int row = indexPath.row;
    int n = [menuTv numberOfRowsInSection:[indexPath section]];
    BOOL isEven = (row % 2 == 0);

    UIImageView *defaultImageView = [[UIImageView alloc] init];
    UIImageView *selectImageView = [[UIImageView alloc] init];

    int background_idx =0;
    if ( !isEven ) {
        background_idx += 4;
    }
    
    if ( n == 1 ) {
        //기본셀
    }
    else {
        if ( row == 0 ) {
            //first
            background_idx+=1;
        }
        else if ( row == n-1 )
        {
            //last
            background_idx+=3;
        }
        else
        {
            //중간
            background_idx+=2;
        }
    }
    NSLog(@"cell idx %d %d ", indexPath.section, indexPath.row);
    [defaultImageView setImage:[cellBackgroundList objectAtIndex:background_idx]];
//    [defaultImageView setImage:[cellBackgroundList objectAtIndex:background_idx+4]];
    
    cell.backgroundView = defaultImageView;
    cell.selectedBackgroundView = selectImageView;
    [defaultImageView release];
    [selectImageView release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* CellIdentifier = @"MoreViewCell";
	MoreViewCell* cell = (MoreViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell)
	{
        NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"MoreViewCell" owner:self options:nil];
        cell = (MoreViewCell*)[objects objectAtIndex:0];
	}
	
	// TODO : refactor
    [cell setTitleForRowAtIndexPath:indexPath];
	[self cellBackGround:cell  ForRowAtIndexPath:indexPath];
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	MoreViewCell* cell = (MoreViewCell*)[tableView cellForRowAtIndexPath:indexPath];
	
	NSString* text = cell.titleLabel.text;

	// 로티플 이용법
	if ([text isEqualToString:@HOWTOUSE])
	{
        
        WhatIsLotipleViewController* whatView = [[WhatIsLotipleViewController alloc] init];
        [whatView setTitle:@"로티플 이용법"];
        [[self navigationController] pushViewController:whatView animated:YES];
        [whatView release];
	}
    // 공지사항
    else if ([text isEqualToString:@NOTICE] )
    {
        MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [TextUtil getURLwithOAuthInfo:@"/m/iphone/notice.jsp"];
        
        [webView openUrl:urlParam];
		[webView setTitle:@NOTICE];
		    [LotipleUtil trackPV:@"/more/notice"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];		
        NSMutableDictionary *plistDict = [Util loadDictionaryFromPlist:@"userActions1.plist"];
        [plistDict setObject:[NSDate date] forKey:@"noticeReadDate"];
        [Util saveDictionary:plistDict ToPlist:@"userActions.plist"];
        [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) hideBadge];
    }
	// 구매이용약관
	else if ([text isEqualToString:@PURCHASETERMS])
	{
		MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [NSString stringWithFormat:@"%@/html/term1.html",
                              [[ServerConnection instance] serverUrl]];
		[webView openUrl:urlParam];
		[webView setTitle:@PURCHASETERMS];
		    [LotipleUtil trackPV:@"/more/term1"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];		

	}
	// 위치정보약관
	else if ([text isEqualToString:@LOCATIONTERMS])
	{
		MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [NSString stringWithFormat:@"%@/html/term2.html",
                              [[ServerConnection instance] serverUrl]];
		[webView openUrl:urlParam];
		[webView setTitle:@LOCATIONTERMS];
		    [LotipleUtil trackPV:@"/more/term2"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];		

	}
    // 위치정보약관
	else if ([text isEqualToString:@PERSONTERMS])
	{
		MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [NSString stringWithFormat:@"%@/html/term4.html",
                              [[ServerConnection instance] serverUrl]];
		[webView openUrl:urlParam];
		[webView setTitle:@PERSONTERMS];
        [LotipleUtil trackPV:@"/more/term4"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];		
        
	}
    // 한줄낙서
    else if ([text isEqualToString:@ONELINE] ) 
    {
        MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [TextUtil getURLwithOAuthInfo:@"/m/community.jsp"];
		[webView openUrl:urlParam];
		[webView setTitle:@ONELINE];
                [LotipleUtil trackPV:@"/more/oneline"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];
    }
    // 1:1 문의 
    else if ([text isEqualToString:@QNA] )
    {
        MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [TextUtil getURLwithOAuthInfo:@"/m/qna.jsp"];
		[webView openUrl:urlParam];
		[webView setTitle:@QNA];
              [LotipleUtil trackPV:@"/more/qna"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];		
    }
    // FAQ
    else if ([text isEqualToString:@FAQ] )
    {
        MoreWebViewController* webView = [[MoreWebViewController alloc] init];
        NSString* urlParam = [TextUtil getURLwithOAuthInfo:@"/m/faq.jsp"];
		[webView openUrl:urlParam];
		[webView setTitle:@FAQ];
		    [LotipleUtil trackPV:@"/more/faq"];
		[[self navigationController] pushViewController:webView animated:YES];
		[webView release];		
    }
    // 신용카드번호저장
    else if ( [text isEqualToString:@CARDSAVE]) 
    {
        CreditCardViewController* cardView = [[CreditCardViewController alloc] init];
      	[[self navigationController] pushViewController:cardView animated:YES];
        [cardView setTitle:@CARDSAVE];
		[cardView release];
    }
    else if ( [text isEqualToString:@CALLCENTER])
    {
        NSString* device = [[UIDevice currentDevice] model];
        if ( [device rangeOfString:@"iPhone"].location != NSNotFound ) 
        {
            [Util showConfirmView:self  andTitle:@PHONECALL andMessage:@"로티플 콜센터로 전화하시겠습니까?"];
        }
        else
        {
            NSString* message = @"이 기기는 전화걸기 기능을 지원하지 않습니다.";
			[Util showAlertView:self message:message];
        }
        
    }

	
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [alertView.title isEqualToString:@PHONECALL] ) {
        if (buttonIndex == 1 )
        {
            // 전화걸기 OK 한 경우
            NSString* callStr = @URL_FOR_CALLCENTER;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
        }
    }
    else if ([alertView.title isEqualToString:@LOGIN_ALERT_LABEL])
    {
        if (buttonIndex == 1 )
        {
            LoginViewController* loginView =[[LoginViewController alloc ] init ]; 
            [[self navigationController] pushViewController:loginView animated:YES];
            [loginView release];
        }
    }
}

- (void)dealloc
{
    [super dealloc];
    [cellBackgroundList release];
}

@end
