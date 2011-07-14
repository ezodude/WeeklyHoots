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
#import "ASIDownloadCache.h"

#import "../JSONKit/JSONKit.h"
#import "MBProgressHUD.h";
#import "FileStore.h"
#import "AudioDownload.h"

@class ASINetworkQueue;
@class ASIHTTPRequest;
@class ASIDownloadCache;

typedef void (^BundleSetupSuccessCallbackBlock)();

#define CACHE_DIR @"/RemoteDataCache"

@interface BundlesManager : NSObject {
    NSString *_programmesAPIURL;
    
    ASINetworkQueue *_bundlesRequestQueue;
    ASIDownloadCache *_remoteDataCache;
    
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_recentBundle;
    
    BOOL _bundlesAvailable;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *recentBundle;
@property (nonatomic, copy) BundleSetupSuccessCallbackBlock bundleSetupSuccessCallbackBlock;

+ (id)manager;

-(void)setupBundlesUsingProgressIndicator:(MBProgressHUD *)progressIndicator WithCallback:(BundleSetupSuccessCallbackBlock)block;
-(BOOL)bundlesAreAvailable;

@end
