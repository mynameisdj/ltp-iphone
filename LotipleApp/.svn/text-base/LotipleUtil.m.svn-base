//
//  LotipleUtil.m
//  LotipleApp
//
//  Created by Dongwoo Kim on 11. 7. 17..
//  Copyright 2011 Home. All rights reserved.
//

#import "LotipleUtil.h"
#import "GANTracker.h"

@implementation LotipleUtil


+ (void) trackPV:(NSString *)url {
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:url
                                         withError:&error]) {
        NSLog(@"error in trackPageview %@", url);
    }
}

+ (void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSInteger)value{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:category
                                         action:action
                                          label:label
                                          value:value
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }

}


@end
