//
//  StoryboxManager.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "FileStore.h"
#import "PlaylistsQueue.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

#import "../JSONKit/JSONKit.h"
#import "MBProgressHUD.h";

@class ASIHTTPRequest;
@class ASIDownloadCache;

typedef void (^StoryboxSetupSuccessCallbackBlock)();

#define CACHE_DIR @"/RemoteDataCache"

@interface StoryboxManager : NSObject {
    NSString *_programmesAPIURL;
    ASIDownloadCache *_remoteDataCache;
    PlaylistsQueue *_playlistsQueue;
}

@property (nonatomic, retain) PlaylistsQueue *playlistsQueue;

+ (id)manager;

-(void)setupPlaylistsQueueUsingProgressIndicator:(MBProgressHUD *)progressIndicator WithCallback:(StoryboxSetupSuccessCallbackBlock)block;

-(void)completePlaylistsQueueSetupFromRequest:(ASIHTTPRequest *)request;
-(void)processFailureForPlaylistsQueueFromRequest:(ASIHTTPRequest *)request;

@end
