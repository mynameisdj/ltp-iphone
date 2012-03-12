//
//  PurchasedCell.m
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 8. 3..
//  Copyright 2011 Home. All rights reserved.
//

#import "PurchasedCell.h"
#import "TextUtil.h"
#import "Tran.h"

@implementation PurchasedCell
@synthesize thumbnail;

- (void)setTran:(Tran*)aTran
{
	[tran release];
	tran = [aTran retain];
    [tran setDelegate:self];
    
    subtitleLb.text = [NSString stringWithFormat:@"%@ %d개", [TextUtil stringByDecodingXMLEntities:tran.deal_title], [tran count]];
	storeNameLb.text = [TextUtil stringByDecodingXMLEntities:tran.store_name ] ;
	couponNameLb.text = [NSString stringWithFormat:@"쿠폰번호:%@",tran.coupon_name];
	remainTimeLb.text = [tran getRemainTime];

    if ( [tran hasLoadedThumbnail] )
    {
        [self setTranCellThumbnail:[tran thumbnail]];
    }
    else
    {
        thumbnailIv.image = [UIImage imageNamed:@"loading_image.png"];
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setTranCellThumbnail: (UIImage * ) image {
    if ( image.size.height > 160 ) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 5, 200, 160));
        [image release];
        UIImage *newImage = [[UIImage alloc] initWithCGImage:imageRef];
        thumbnailIv.image = newImage;
        tran.thumbnail = newImage;
        CGImageRelease(imageRef);
    }
    else {
        thumbnailIv.image = image;
        tran.thumbnail = image;
    }
}

- (void)loadImage
{
    UIImage *image = tran.thumbnail;
    if ( image == nil )
    {
        ;
    } 
    else {
        thumbnailIv.image = image;
    }
}

#pragma mark - DealImageDelegate
- (void)couldNotLoadImageError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)didLoadImage:(UIImage *)image;
{
    [self setTranCellThumbnail:image];
}



@end
