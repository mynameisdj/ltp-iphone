//
//  LotipleAppAppDelegate.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 12..
//  Copyright 2011 Home. All rights reserved.
//

#import "LotipleAppAppDelegate.h"

#import "Settings.h"
#import "ServerConnection.h"
#import "ListViewController.h"

#import "PurchaseWebViewController.h"
#import "UserManager.h"
#import "libkern/OSAtomic.h"
#import "GANTracker.h"
#import "LTPConstant.h"
#import "Util.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation LotipleAppAppDelegate

@synthesize window=_window;
@synthesize customTabbarView, tabbarNib;

@synthesize tabBarController=_tabBarController;
@synthesize listNavController, mapNavController, mypageNavController, moreNavController;

- (void)setupGoogleAnalytics{
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-23062288-4"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
    NSError *error;
    
    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                         name:@"app_version"
                                                        value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
                                                        scope:1
                                                    withError:&error]) {
        NSLog(@"error in setCustomVariableAtIndex");
    }
    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:2
                                                         name:@"user_type"
                                                        value: (( [[ServerConnection instance] logged] ) ? @"member" : @"visitor" )
                                                        scope:2
                                                    withError:&error]) {
        NSLog(@"error in setCustomVariableAtIndex");
    }
    
    [LotipleUtil trackEvent:@"Application iPhone" action:@"Launch iPhone" label:@"Example iPhone" value:99];
    [LotipleUtil trackPV:@"/app_entry_point"];
}


#pragma mark tabbar

- (void) showTabbar {
    customTabbarView.hidden = NO;
}
- (void) hideTabbar {
    customTabbarView.hidden = YES;
}

- (void) showBadge {
    moreBadge.hidden = NO;
}

- (void) hideBadge {
    moreBadge.hidden = YES;
}

- (void) onNotifyNoticeUpdatedTime:(NSDate *)serverDate { // server Info 에서 
    //get server time info
    NSDictionary *plistDict = [Util loadDictionaryFromPlist:@"userActions.plist"];
    NSDate *readDate = [plistDict objectForKey:@"noticeReadDate"];
    NSLog(@"%s %@ %@",__FUNCTION__, serverDate, readDate);
    if ( readDate == nil || [readDate compare:serverDate] == NSOrderedAscending ) {
        [self showBadge];
    }
}

- (IBAction) tabbarTouched:(id)sender {
    static id cached_button = 0;
    static UIImage *original = nil;
    UIButton *touched = (UIButton *)sender;
    int idx = touched.tag;
    if (cached_button == touched) {
        [[self.tabBarController.viewControllers objectAtIndex:idx] popToRootViewControllerAnimated:YES];
    } else {
        if ( original != nil )
            [cached_button setImage:original forState:UIControlStateNormal];
        if (cached_button != 0) ( [ cached_button setSelected:NO]);
        original = [[touched imageForState:UIControlStateNormal] retain];
        [touched setImage:[touched imageForState:UIControlStateSelected ] forState:UIControlStateNormal];
    }
    [touched setSelected:YES];
    cached_button = touched;
    [self.tabBarController setSelectedIndex:idx];
}

- (void) setSelectedIdx:(NSInteger)idx {
    if (idx < [tabbarButtons count] )
        [self tabbarTouched:[tabbarButtons objectAtIndex:idx]];
}

- (void) setupTabbar {
    [self.window addSubview:self.tabBarController.view];
    self.tabBarController.tabBar.hidden = YES;
    [self.tabBarController.view setFrame:CGRectMake(0, 20, 320, 460)];
    self.tabbarNib = [UINib nibWithNibName:@"Tabbar" bundle:nil];
    [self.tabbarNib instantiateWithOwner:self options:nil];
    [customTabbarView setFrame:CGRectMake(0, 420, 320, 60)];
    tabbarButtons = [[NSMutableArray alloc] initWithCapacity:3];
    for (UIView *view in [customTabbarView subviews] ){
        if ( [view isKindOfClass:[UIButton class]]){
            [tabbarButtons addObject:view];
        }
    }
    [self.window addSubview:customTabbarView];
    [self.window bringSubviewToFront:customTabbarView];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 서버설정
    [self setupGoogleAnalytics];
    
    [self setupTabbar];
    [self setSelectedIdx:0];    [self setSelectedIdx:2];    [self setSelectedIdx:0]; //iOS5 bug때문에 임시로..
    
    [self.window makeKeyAndVisible];
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
                                                                                                                                    
	// 락먼저 생성
	busyLock = [[NSLock alloc] init];
    
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(timerProc:) userInfo:nil repeats:YES];
	
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if( userInfo )
    {
        int deal_id = [[userInfo objectForKey:@"deal_id"] intValue];
        [self showDealDetail:deal_id];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */

	[[Settings instance] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
	
	[[Settings instance] save];
	
}

- (void)dealloc
{
    [[GANTracker sharedTracker] stopTracker];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (void)timerProc:(id)sender
{
	// mainthread 가 아래 로직을 호출하게 될꺼야
	// 다른 쓰레드들이 internetAiv 암만 건드려봐야 작동하지 않는다 ㅠ
	if (internetAiv)
	{
		if (busyCounter <= 0)
		{
			[internetAiv stopAnimating];
			[internetAiv removeFromSuperview];
			[internetAiv release];
			internetAiv = nil;
		}
		else
		{
			UIViewController* selView = self.tabBarController.selectedViewController;
			if (selView.navigationController.visibleViewController)
				selView = selView.navigationController.visibleViewController;
			
			if (selView.view != [internetAiv superview])
			{
				[internetAiv removeFromSuperview];
				[selView.view addSubview:internetAiv];
			}
		}
	}
}

- (void)showBusyIndicator:(BOOL)show
{
	[busyLock lock];
	
	if (show)
		busyCounter += 1;
	else
		busyCounter -= 1;
	
	if (busyCounter < 0)
	{
		NSLog(@"BusyCounter became minus!");
        busyCounter = 0;		
	}
	else if (busyCounter == 0)
	{
		NSLog(@"BusyIndicator disappeared");
	}
	else if (!internetAiv)
	{
		internetAiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		CGRect frame = internetAiv.frame;
		frame.origin.x = 160 - frame.size.width/2;
		frame.origin.y = 220;
		[internetAiv setFrame:frame];
		[internetAiv startAnimating];

		NSLog(@"BusyIndicator appeared");
	}
	else
	{
		NSLog(@"BusyIndicator counter - %d", busyCounter);
	}
	
	[busyLock unlock];
}



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		NSLog(@"cancel");
	}
	else if (buttonIndex == 1)
	{
        // 업데이트 
		NSLog(@"update");
        NSString* requestString = @UPDATE_URL_LOTIPLE_APP; 
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:requestString]];
	}
    else
        NSLog(@"button_rest");
}

#pragma mark - push notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken : %@", token);
    [[ServerConnection instance] setDeviceToken:token];
    [[UserManager instance] server_registerDeviceToken:token];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"deviceToken error : %@", error); 
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString* message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    BOOL isNotice = NO;
    if ( [userInfo valueForKey:@"isNotice"] != nil ) {
        isNotice = YES;
    }
    int deal_id = -1;
    if ( [userInfo valueForKey:@"deal_id"] != nil ) {
        deal_id = [[userInfo valueForKey:@"deal_id"] intValue];
    }
    
    if ( isNotice ) {
        if( application.applicationState == UIApplicationStateActive )
        {
            [Util showAlertView:self message:message];
        }   
        else {
            if ( [userInfo valueForKey:@"hasNewVersion"] != nil ) {
                // start download
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@UPDATE_URL_LOTIPLE_APP]];
            }
        }
    }
    else {
        if( application.applicationState == UIApplicationStateActive )
        {
            [Util showAlertView:self message:message];
        }
        else
        {
            [self showDealDetail:deal_id];
        }
    }
    
    application.applicationIconBadgeNumber = 0;
}

- (void)showDealDetail:(int)deal_id
{
    NSLog(@"showDealDetail in LotipleApp");
    UINavigationController* navigation = (UINavigationController*)[[self.tabBarController viewControllers] objectAtIndex:0];
    ListViewController* listView = (ListViewController*)[[navigation viewControllers] objectAtIndex:0];
    UIViewController* topView = [navigation topViewController];
    if([listView isViewLoaded] && listView == topView)  // list tab 에 있는가
    {
        [listView showDealDetail:deal_id];
    }
    else
    {   
        listView.forceViewDealDetail = deal_id;
        [navigation popToRootViewControllerAnimated:NO];
        [((LotipleAppAppDelegate *)[[UIApplication sharedApplication] delegate]) setSelectedIdx: 0];
    }
 

}

+ (void)showBusyIndicator:(BOOL)show
{
	LotipleAppAppDelegate* lotipleApp =  (LotipleAppAppDelegate*)[[UIApplication sharedApplication] delegate];
	[lotipleApp showBusyIndicator:show];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ( url == nil )
        return NO;
    NSString *URLString = [url absoluteString];
    NSArray *firstSplit = [URLString componentsSeparatedByString:@"/"];
    //   NSString *message = [NSString stringWithFormat:@"openURL%@ %@ %@ %@", [firstSplit objectAtIndex:0], [firstSplit objectAtIndex:1], [firstSplit objectAtIndex:2], [firstSplit objectAtIndex:3]];
    //  [LotipleAppAppDelegate showAlertView:nil message:message];
    if ( [firstSplit count] == 4  ) {
        int deal_id = [[firstSplit objectAtIndex:3] intValue];
        [self showDealDetail:deal_id];
    }
    else
    {
        return NO;
    }
    return YES;
}
@end
