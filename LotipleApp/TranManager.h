//
//  TranManager.h
//  LotipleApp
//
//  Created by DongJoo Kim on 11. 8. 5..
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerOperationDelegate.h"
#import "ServerHelper.h"
#import "DataManagerDelegate.h"


@interface TranManager : NSObject <ServerOperationDelegate, UIAlertViewDelegate> {
    NSMutableArray* tranList;
    ServerHelper* serverHelper;
    NSObject<DataManagerDelegate> *delegate;
    
}

@property (nonatomic, retain) NSMutableArray* tranList;
@property (nonatomic, retain) NSObject<DataManagerDelegate> *delegate;

+ (id)instance;
- (void)removeTran;
-(void)appendTranToList:(NSArray*)tranListFromServer;
-(void)server_refreshTranList;
@end
