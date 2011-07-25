//
//  StoryboxManager.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "StoryboxManager.h"


@implementation StoryboxManager

@synthesize playlistsQueue=_playlistsQueue;

- (id)init {
    self = [super init];
    
    if (self) {
        _programmesAPIURL = [[Environment sharedInstance] programmesAPIURL];
        NSString *cachePath = [FileStore createDirectoryPath:[NSString stringWithFormat:@"%@/%@", [FileStore applicationDocumentsDirectory], CACHE_DIR]];
        
        _remoteDataCache = [[ASIDownloadCache alloc] init]  ;
        [_remoteDataCache setStoragePath:cachePath];
    }
    return self;
}

+ (id)manager
{
	return [[[self alloc] init] autorelease];
}

-(void)setupPlaylistsQueueUsingProgressIndicator:(MBProgressHUD *)progressIndicator WithCallback:(StoryboxSetupSuccessCallbackBlock)block{
    NSLog(@"setting up Playlists Queue");
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@playlists/queue.json", _programmesAPIURL]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDownloadCache:_remoteDataCache];
    
    // Simplest Cache Policy, optimised for when user is offline.
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [request setCompletionBlock:^{
        NSLog(@"Starting setCompletionBlock");
        [self completePlaylistsQueueSetupFromRequest:request];
        block();
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Starting setFailedBlock");
        [self processFailureForPlaylistsQueueFromRequest:request];
    }];
    
    [request startAsynchronous];
}

-(void)completePlaylistsQueueSetupFromRequest:(ASIHTTPRequest *)request{
    NSLog(@"Completing Playlists Queue Setup");
    
    NSString *responseString = [request responseString];
    NSDictionary *dictionary = (NSDictionary *)[responseString objectFromJSONString];
    
    PlaylistsQueue *newPlaylistsQueue = [[PlaylistsQueue alloc] initFromDictionary:dictionary];
    self.playlistsQueue = newPlaylistsQueue;
    
    [newPlaylistsQueue release];
}

-(void)processFailureForPlaylistsQueueFromRequest:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"Error processing Playlists Queue: %@",[error localizedDescription]);
}

- (void)dealloc {
    [_programmesAPIURL release];
    [_remoteDataCache release];
    [self.playlistsQueue release];
    [super dealloc];
}

@end
