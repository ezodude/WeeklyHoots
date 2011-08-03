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

#import "Storybox.h"
#import "PlaylistsQueue.h"

#import "PlaylistDownload.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

#import "../JSONKit/JSONKit.h"
#import "MBProgressHUD.h";

@class Storybox;
@class ASIHTTPRequest;
@class ASIDownloadCache;

typedef void (^StoryboxSetupSuccessCallbackBlock)();

#define CACHE_DIR @"/RemoteDataCache"

@interface StoryboxManager : NSObject {
    NSString *_programmesAPIURL;
    ASIDownloadCache *_remoteDataCache;
    Storybox *_storybox;
    
    NSOperationQueue *_playlistsProcessingQueue;
}

@property (nonatomic, retain) Storybox *storybox;

+ (id)manager;

-(void)setupStoryboxUsingProgressIndicator:(MBProgressHUD *)progressIndicator WithCallback:(StoryboxSetupSuccessCallbackBlock)block;

-(void)completeSetupFromRequest:(ASIHTTPRequest *)request;
-(void)processFailureFromRequest:(ASIHTTPRequest *)request;

-(void)appendPlaylistToStorybox:(Storybox *)storybox forGuid:(NSString *)playlistGuid;

@end
