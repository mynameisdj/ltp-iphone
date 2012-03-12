//
//  ZoneViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 15..
//  Copyright 2011 Home. All rights reserved.
//

#import "ZoneViewController.h"
#import "ZoneViewCell.h"
#import "ServerConnection.h"
#import "Area.h"
#import "AreaManager.h"
#import "ListViewController.h"
#import "LotipleAppAppDelegate.h"
#import "Util.h"

@implementation ZoneViewController

@synthesize areaArray;
@synthesize customNavigationItem;
NSIndexPath *_lastIndex;

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

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) hideTabbar];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) showTabbar];

}

- (void) initCloseButton {
    UIView *viewForRight = [Util lotipleButtonView:@"닫기" target:self action:@selector(buttonClicked:)];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:viewForRight];
    [customNavigationItem setRightBarButtonItem:rightBtn animated:YES];
    [rightBtn release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view Did load");
    [self initCloseButton];
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


#pragma mark - UI Event Handler

- (IBAction)buttonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath == _lastIndex)
        return;
    
    ZoneViewCell *cell = (ZoneViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [[AreaManager instance] setCurrentAreaName:cell.titleLabel.text];
    _lastIndex = indexPath;
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{	
	switch (section)
	{
        case 0:
            return @"로티플";
	}
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
        return [[[AreaManager instance] areaList] count];
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}

static NSArray *cellBackgroundList;
static NSArray *cellBackgroundListTouch;
static BOOL backgroundLoaded = NO,backgroundLoadedTouch = NO;
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
    if ( !backgroundLoadedTouch ) {
        cellBackgroundListTouch  = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"whiteDownBar.png"],
                               [UIImage imageNamed:@"whiteUpBar.png"],
                               [UIImage imageNamed:@"whiteMidBar.png"],
                               [UIImage imageNamed:@"whiteDownBar.png"],
                               [UIImage imageNamed:@"grayUpBar.png"],
                               [UIImage imageNamed:@"grayUpBar.png"],
                               [UIImage imageNamed:@"grayMidBar.png"],
                               [UIImage imageNamed:@"grayDownBar.png"],nil];
    }
    
    int row = indexPath.row;
    int n = [areaTable numberOfRowsInSection:[indexPath section]];
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
    static NSString* CellIdentifier = @"ZoneCell";
    
	ZoneViewCell* cell = (ZoneViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
	{
        cell = (ZoneViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ZoneViewCell" owner:self options:nil] objectAtIndex:0];
    }
	
	NSString* zoneText = @"";
    NSLog(@"indexpath.section is %d row is %d", indexPath.section, indexPath.row);
    if (indexPath.section == 0)
	{
        Area* this_area = [[[AreaManager instance] areaList] objectAtIndex:indexPath.row];
        [this_area retain];
        zoneText = this_area.name;
        [this_area release];
        NSLog(@"currentAreaName ");
        if ( [zoneText isEqualToString:[[AreaManager instance] currentAreaName]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _lastIndex = indexPath;
        }
        else {
            ;//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.titleLabel.text = zoneText;
	}
    [self cellBackGround:cell  ForRowAtIndexPath:indexPath];
    
    return cell;
}


@end
