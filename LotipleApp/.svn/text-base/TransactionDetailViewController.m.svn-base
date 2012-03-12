//
//  TransactionDetailViewController.m
//  LotipleApp
//
//  Created by lotiple on 11. 5. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "Tran.h"
#import "ServerConnection.h"
#import "LotipleAppAppDelegate.h"
#import "DealItem.h"
#import "TextUtil.h"
#import "Util.h"
#import "LTPConstant.h"


@implementation TransactionDetailViewController

static NSString* PhoneCall = @"전화걸기";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( nibNameOrNil == nil ) 
        nibNameOrNil = @"TransactionDetailViewController";
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTran:(Tran*)_tran
{
    self = [super init];
    if ( self) {
        tran = _tran;
        [tran retain];
    }
    return self;
}

-(void)setTranUI
{
    NSLog(@"deal's and lng lat is %f %f", [[tran deal] lng] , [[tran deal] lat]);
    storenameLb.text = [TextUtil stringByDecodingXMLEntities:tran.store_name];
    couponStringLb.text = tran.coupon_name;
    remainTimeLb.text = [tran getRemainTime];
    dealtitleLb.text = [TextUtil stringByDecodingXMLEntities:tran.deal_title];
    NSLog(@"status is %d", tran.status);
    statusLb.text = [tran getStatusString];
    totalPriceLb.text = [TextUtil getFormattedPrice:[tran total_price]];
    addressLb.text = tran.store_address;
    address2Lb.text = tran.store_address2;
    countLb.text = [NSString stringWithFormat:@"%d 개", [tran count] ];
    purchaseTimeLb.text = [self getPurchaseTimeString:tran.purchase_time];
    phoneLb.text = tran.phone;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"AppleGothic" size: 20.0];
    [label setMinimumFontSize:10.0];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:[TextUtil stringByDecodingXMLEntities:@"쿠폰상세"]];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
    [label release];
    
    CGSize newContenetSize = ((UIScrollView*)self.view).contentSize;
    newContenetSize.height = 500;
    [((UIScrollView*)self.view) setContentSize:newContenetSize];
}


- (void)dealloc
{
    [mapBtn release];
    [tran release];
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
    NSLog(@"did koad");
    [self setTranUI];
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

- (NSString* ) getPurchaseTimeString:(NSDate*)purchase_time
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy년MM월dd일 hh시mm분"];
    return [df stringFromDate:purchase_time];
}

- (IBAction)buttonClicked:(id)sender 
{
    if ( sender == mapBtn ) 
    {
        NSString *latlngStr = [[NSString stringWithFormat:@"%@@%f,%f",tran.store_name, [tran deal].lat, [tran deal].lng ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?z=15&q=%@",latlngStr]]];
    }
    else if ( sender == callBtn)
    {
        NSString* device = [[UIDevice currentDevice] model];
        
        if ([device rangeOfString:@"iPhone"].location != NSNotFound ) {
            
            [Util showConfirmView:self andTitle:PhoneCall andMessage:@"상점으로 전화거시겠습니까?" ];
        }
        else
        {
            NSString* message = @"이 기기는 전화걸기 기능을 지원하지 않습니다.";
			[Util showAlertView:self message:message];
        }

    }
    
}
// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [alertView.title isEqualToString:PhoneCall] ) 
    {
        if ( buttonIndex == 1 && [phoneLb.text isEqualToString:@"없음"] == NO ) 
        {
            // 전화걸기 OK 한 경우
            NSString* callStr = [NSString stringWithFormat:@"tel://%@", phoneLb.text];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
        }
    }
}


@end
