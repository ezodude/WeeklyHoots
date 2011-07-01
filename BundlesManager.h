//
//  BundlesManager.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 30/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "WeeklyBundle.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "../JSONKit/JSONKit.h"

@class ASINetworkQueue;
@class ASIHTTPRequest;

typedef void (^BundleSetupSuccessCallbackBlock)();

@interface BundlesManager : NSObject {
    NSString *_programmesAPIURL;
    ASINetworkQueue *_bundlesRequestQueue;
    
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_recentBundle;
    
    BOOL _bundlesAvailable;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *recentBundle;
@property (nonatomic, copy) BundleSetupSuccessCallbackBlock bundleSetupSuccessCallbackBlock;

+ (id)manager;
-(void)setupBundlesWithCallback:(BundleSetupSuccessCallbackBlock)block;
-(BOOL)bundlesAreAvailable;

@end
