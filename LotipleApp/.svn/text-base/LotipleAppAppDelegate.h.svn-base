//
//  LotipleAppAppDelegate.h
//  LotipleApp
//
//  Created by kueecc on 11. 4. 12..
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LotipleAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>
{
	UIActivityIndicatorView* internetAiv;
	NSLock* busyLock;
	int busyCounter;
	NSTimer* busyOffTimer;
    NSOperationQueue* queue;
    
    UINib *tabbarNib;
    
@private 
    NSMutableArray *tabbarButtons;
    IBOutlet UIImageView *moreBadge;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *listNavController, *mapNavController, *mypageNavController, *moreNavController;
@property (nonatomic, retain) IBOutlet UIView *customTabbarView;
@property (nonatomic, retain) UINib *tabbarNib;


- (void)timerProc:(id)sender;
- (void)showDealDetail:(int)deal_id;
+ (void)showBusyIndicator:(BOOL)show;


- (void) showTabbar;
- (void) hideTabbar;
- (void) hideBadge;
- (void) setSelectedIdx:(NSInteger)idx;
- (void) onNotifyNoticeUpdatedTime:(NSDate *)serverDate;

@end
