//
//  DataManagerDelegate.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 7..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataManagerDelegate 

@required
- (void) didDataUpdateSuccess;
- (void) didDataUpdateFail:(NSString*)errorMsg;
@end
