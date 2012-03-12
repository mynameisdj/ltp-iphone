//
//  MoreViewCell.m
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 7. 27..
//  Copyright 2011 Home. All rights reserved.
//

#import "MoreViewCell.h"
#import "ServerConnection.h"
#import "TextUtil.h"
#import "LTPConstant.h"
#import "Util.h"

@implementation MoreViewCell
@synthesize titleLabel;
@synthesize haveNew;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setTitleForRowAtIndexPath:(NSIndexPath *)indexPath {
    haveNew.hidden = YES;
    if (indexPath.section == 0)
	{
        if ( indexPath.row == 0 ) {
            // 로티플이란
            titleLabel.text = @HOWTOUSE;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1 ) {
            
            titleLabel.text = @NOTICE;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSDate *serverDate = [ServerConnection instance].lastEventUpdateTime;

            NSDictionary *plistDict = [Util loadDictionaryFromPlist:@"userActions.plist"];
            NSDate *readDate = [plistDict objectForKey:@"noticeReadDate"];
            NSLog(@"%s %@ %@",__FUNCTION__, serverDate, readDate);
            if ( readDate == nil || [readDate compare:serverDate] == NSOrderedAscending ) {
                [haveNew setHidden:NO];
                [haveNew setImage:[UIImage imageNamed:@"more_badge.png"]];
            } 
        }
        else if (indexPath.row == 2){
            titleLabel.text = @ONELINE;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            titleLabel.text = @INVITE;
            [haveNew setHidden:NO];
            haveNew.frame = CGRectMake(130, 5, 25, 25);
            [haveNew setImage:[UIImage imageNamed:@"more_badge.png"]];
        }
	}
    else if (indexPath.section == 1)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 0 )
        {
            titleLabel.text = @FAQ;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1)
        {
            titleLabel.text = @QNA;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 2 )
        {
            titleLabel.text = @CALLCENTER;
        }
        else
        {
            titleLabel.text = [NSString stringWithFormat:@"버전 정보: %@", [TextUtil getVerStrWithDots]];
            
        }
        
    }
	else if (indexPath.section == 2)
	{
		// 약관
		if (indexPath.row == 0)
		{
			titleLabel.text = @PURCHASETERMS;
		}
		else if ( indexPath.row == 1 )
		{
			titleLabel.text = @LOCATIONTERMS;
		}
        else if ( indexPath.row == 2 )
        {
            titleLabel.text = @PERSONTERMS;
        }
        
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    else if (indexPath.section == 3)
    {
        titleLabel.text = [NSString stringWithFormat:@"%@",[[ServerConnection instance] serverUrl] ] ;
    }

}

- (void)dealloc
{
    [super dealloc];
}


@end
