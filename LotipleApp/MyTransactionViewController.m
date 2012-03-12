//
//  MyTransactionViewController.m
//  LotipleApp
//
//  Created by lotiple on 11. 5. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import "MyTransactionViewController.h"
#import "TransactionDetailViewController.h"
#import "ServerConnection.h"
#import "LotipleAppAppDelegate.h"
#import "LoginViewController.h"
#import "TranManager.h"
#import "Tran.h"
#import "Util.h"
#import "ServerUrls.h"
#import "JSONKit.h"
#import "ServerHelper.h"
#import "LTPConstant.h"

@implementation MyTransactionViewController

@synthesize PurchasedCellNib, purchasedCellProto;
@synthesize transArray;

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
    self.PurchasedCellNib = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) unusedSelected:(id)sender {
    if (  !showingUnused ) {
        showingUnused = YES;
        [segmentedUnusedUIButton setSelected:YES];
        [segmentedUsedUIButton setSelected:NO];
        [itemsTv reloadData];
    }
}

- (IBAction) usedSelected:(id)sender {
    if (  showingUnused ) {
        showingUnused = NO;
        [segmentedUnusedUIButton setSelected:NO];
        [segmentedUsedUIButton setSelected:YES];
        [itemsTv reloadData];
    }
    [self loadContentForVisibleCells];
}

- (void) setSegmentedControl {
    showingUnused = YES;
    [segmentedUnusedUIButton setSelected:YES];
    [segmentedUsedUIButton setSelected:NO];    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
   	[super viewWillAppear:animated];
    
    // TODO : 임시로..
    if ([[ServerConnection instance] logged] == NO )
    {
        [Util showLoginView:self message:@"구매내역을 확인하시기 위해서는 로그인이 필요합니다."];
        return;
    }
    [[TranManager instance] server_refreshTranList];
    [self loadContentForVisibleCells];
    [LotipleUtil trackPV:@"/my_page"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
}

-(void)updateTranList
{
    self.transArray = [NSMutableArray arrayWithArray:[[TranManager instance] tranList]];
    [unusedTransArray removeAllObjects];
    [usedTransArray removeAllObjects];
    NSDate* now = [NSDate dateWithTimeIntervalSinceNow:0];
    for ( Tran *tran in transArray) {

        // 미사용인데다가 아직 마감시간이 남았으면, 
        if ( ([ tran status] == TRANSACTION_ORDERED ) && ( [tran.end_time compare:now] == 1 ) )
        {
            [unusedTransArray addObject:tran];
        }
        else
        {
            [usedTransArray addObject:tran];
        }
    }
    [itemsTv reloadData];
}

#pragma mark - DataManagerDeleagate
- (void) didDataUpdateSuccess
{
    [self updateTranList];
    [LotipleAppAppDelegate showBusyIndicator:NO];
}
- (void) didDataUpdateFail:(NSString*)errorMsg
{
    [LotipleAppAppDelegate showBusyIndicator:NO];
    [Util showLoginView:self message:errorMsg];

}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"My Transaction View Controller viewDidLoad");
    [super viewDidLoad];
    [self setSegmentedControl];
    
    unusedTransArray = [[NSMutableArray alloc] init];
    usedTransArray = [[NSMutableArray alloc] init];
    
    serverHelper = [[ServerHelper alloc] initWithDelegate:(NSObject<ServerOperationDelegate>*)self];
    [[TranManager instance] setDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
       
	self.navigationItem.title = @"구매한쿠폰 ";
	itemsTv.separatorColor = RGB(238,238,238);
    
    self.PurchasedCellNib = [UINib nibWithNibName:@"PurchasedCell" bundle:nil];
}

- (void)viewDidUnload
{
    [unusedTransArray release];
    [usedTransArray release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
    NSLog(@" did select row in mypageeeeeee");
    if ( [transArray count] == 0 ) 
        return ;
    NSLog(@" did select row in mypageeeeeee");
    Tran* tran = [transArray objectAtIndex:indexPath.row];
    TransactionDetailViewController* tranDetailView = [[TransactionDetailViewController alloc] initWithTran:tran ] ;
    
    [[self navigationController] pushViewController:tranDetailView animated:YES];
    [tranDetailView release];
}

#pragma mark - UIScrollViewDelegate

- (void)loadContentForVisibleCells
{
    NSArray *cells = [itemsTv visibleCells];
    [cells retain];
    for (int i = 0; i < [cells count]; i++) 
    { 
        // Go through each cell in the array and call its loadContent method if it responds to it.
        PurchasedCell *purchasedCell = (PurchasedCell *)[[cells objectAtIndex: i] retain];
        if ( [purchasedCell respondsToSelector:@selector(loadImage) ] ) 
        {
            [purchasedCell loadImage];
        }            
        [purchasedCell release];
        purchasedCell = nil;
        
    }
    [cells release];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    [self loadContentForVisibleCells]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) 
    {
        [self loadContentForVisibleCells]; 
    }
	
}


#pragma mark - UITableViewDataSource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    int n = 0;
    if (showingUnused)
        n = [unusedTransArray count];
    else 
        n = [usedTransArray count];
    if ( n == 0 )
        return 1;
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int n;
    if (showingUnused)
        n = [unusedTransArray count];
    else 
        n = [usedTransArray count];

    if ( n != 0 ) {
        static NSString* TranCellIdentifier = @"PurchasedDealCell";	
        PurchasedCell* cell = (PurchasedCell*)[tableView dequeueReusableCellWithIdentifier:TranCellIdentifier];
        if (!cell)
        {
            [self.PurchasedCellNib instantiateWithOwner:self options:nil];
            cell = purchasedCellProto;
            self.purchasedCellProto = nil;
        }
        
        Tran* tran;
        if (showingUnused)
            tran = [unusedTransArray objectAtIndex:indexPath.row];
        else 
            tran = [usedTransArray objectAtIndex:indexPath.row];
        [cell setTran:tran];
        if ( indexPath.row < 4 ){
            [cell loadImage];
        }
    
        return cell;
    }
    else 
    {
        static NSString* CellIdentifier = @"CellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            if (showingUnused)
                cell.textLabel.text = @"사용가능한 쿠폰이 없습니다.";
            else 
                cell.textLabel.text = @"구매내역이 없습니다.";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        return cell;
    }

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		NSLog(@"button index 0 ");
	}
	else if (buttonIndex == 1)
	{      
        LoginViewController* loginView =[[LoginViewController alloc ] init ]; 
        [[self navigationController] pushViewController:loginView animated:YES];
        [loginView release];
	}
    else
        NSLog(@"button rest ..");
}

@end
