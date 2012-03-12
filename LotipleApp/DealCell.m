//
//  DealCell.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 14..
//  Copyright 2011 Home. All rights reserved.
//

#import "DealCell.h"
#import "DealItem.h"
#import "TextUtil.h"
#import "Util.h"
#import "ServerConnection.h"
#import "UITimeboxView.h"

@implementation DealCell

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

- (void)dealloc
{
	[deal release];
    [super dealloc];
}


- (void)setDeal:(DealItem*)aDeal
{
	[deal release];
	deal = [aDeal retain];
    
    [deal setDelegate:self];
    

    if ( [deal hasLoadedThumbnail] )
    {
        [self setDealCellThumbnail:[deal thumbnail]];
    }
    else
    {
        thumbnailIv.image = [UIImage imageNamed:@"loading_image.png"];
    }
    [remainTimeLb setTextColor:RGB(255, 0, 128)];
    
    /*
    if( ![deal isDealStarted] )
    {		
        [remainTimeLb setTextColor:RGB(0x0a, 0xb1, 0xf0)];
    }
    else {
        [remainTimeLb setTextColor:RGB(255, 0, 128)];
    }*/
    
    float distance = [[ServerConnection instance] getDistance:deal];
    
    if (distance <= 0.0f)
    {
        distanceLb.text = @"";
        // 0m 일리가 없어! 이건 아직 내 위치를 못받아 온거야.
        [[ServerConnection instance] addLocationListener:self];
    }
    else
    {
        distanceLb.text = [NSString stringWithFormat:@"%dkm", (int)(distance/1000.0f)];
        if (distance/1000.0f > 99.0f) {
            distanceLb.text = @"99km+";
        } else if ( distance / 1000.0f < 1.0f ) {
            distanceLb.text = [NSString stringWithFormat:@"%dm", (int)distance];
        }
    }	
	remainTimeLb.text = [deal getRemainTime];
    titleLb.text = [TextUtil stringByDecodingXMLEntities: [deal title] ];
    storeNameLb.text = [TextUtil stringByDecodingXMLEntities:[deal store_name]];
    if ([deal discount_rate] == 0 ) {
        discountRateLb.hidden =YES;
        priceDownIv.hidden = YES;
        betweenPriceAndDiscount.hidden = YES;
        priceLb.hidden = YES;
        goLeftIv.hidden = YES;
    }
    else {
        discountRateLb.hidden =NO;
        priceDownIv.hidden = NO;
        discountRateLb.text = [NSString stringWithFormat:@"(%d%%   )",[deal discount_rate] ];
        betweenPriceAndDiscount.hidden = NO;
        priceLb.hidden = NO;
        goLeftIv.hidden = NO;
    }
        
    priceLb.text = [TextUtil getFormattedPrice:[deal price]];
    rpriceLb.text = [TextUtil getFormattedPrice:[deal price]];
	rpriceLb.text = [TextUtil getFormattedPrice:[deal reduced_price]];
	descLb.text = [TextUtil stringByDecodingXMLEntities:[deal description]];

    soldoutRibbonIv.hidden = ( deal.max_count - deal.current_ordered_count >0 );
}

- (void) setDealCellThumbnail: (UIImage * ) image {
    if ( image.size.height > 160 ) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 5, 200, 160));
        NSLog(@"before release");
        [image release];
        UIImage *newImage = [[UIImage alloc] initWithCGImage:imageRef];
        thumbnailIv.image = newImage;
        if ( deal != nil && newImage != nil)
        {
            NSLog(@"before setThumbnail");
            [deal setThumbnail:newImage];
            NSLog(@"after setThumbnail");
        }
        CGImageRelease(imageRef);
    }
    else {
        thumbnailIv.image = image;
        [deal setThumbnail:image];
    }
}

- (void)loadImage
{
    UIImage *image = deal.thumbnail;
    if (image == nil)
    {
        ;
    }
    else 
    {
        thumbnailIv.image = image;
    }
}


#pragma mark - CLLocationManagerDelegate

//위치가 변경되었을때 호출.
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
	float distance = [[ServerConnection instance] getDistance:deal];
	distanceLb.text = [NSString stringWithFormat:@"%.1fkm", distance/1000.0f];
	NSLog(@"after update location, distance is %f", distance);
	[[ServerConnection instance] removeLocationListener:self];
}

//위치를 못가져왔을때 에러 호출.
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    ;
}

#pragma mark - DealImageDelegate
- (void)couldNotLoadImageError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didLoadImage:(UIImage *)image;
{
    [self setDealCellThumbnail:image];
}

@end
