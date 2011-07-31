//
//  StoryboxManager.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "StoryboxManager.h"


@implementation StoryboxManager

@synthesize storybox=_storybox;

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

-(void)setupStoryboxUsingProgressIndicator:(MBProgressHUD *)progressIndicator WithCallback:(StoryboxSetupSuccessCallbackBlock)block{
    NSLog(@"setting up Playlists Queue");
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@playlists/queue.json", _programmesAPIURL]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDownloadCache:_remoteDataCache];
    
    // Simplest Cache Policy, optimised for when user is offline.
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [request setCompletionBlock:^{
        NSLog(@"Starting setCompletionBlock");
        [self completeSetupFromRequest:request];
        block();
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Starting setFailedBlock");
        [self processFailureFromRequest:request];
    }];
    
    [request startAsynchronous];
}

-(void)completeSetupFromRequest:(ASIHTTPRequest *)request{
    NSLog(@"Completing Playlists Queue Setup");
    
    NSString *responseString = [request responseString];
    NSDictionary *dictionary = (NSDictionary *)[responseString objectFromJSONString];
    
    PlaylistsQueue *newPlaylistsQueue = [[PlaylistsQueue alloc] initFromDictionary:dictionary];
    
    Storybox *newStorybox = [[Storybox alloc] init];
    [newStorybox loadAndsetupWithPlaylistsQueue:newPlaylistsQueue];
    
    [newStorybox synchronizeWithLocalStorage];
    self.storybox = newStorybox;
    
    [newPlaylistsQueue release];
    [newStorybox release];
}

-(void)processFailureFromRequest:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"Error processing Playlists Queue: %@",[error localizedDescription]);
}

-(void)appendPlaylistsToStorybox:(Storybox *)storybox forGuids:(NSArray *)playlistGuids{
    // loop through playlists guids
        // initialise a NSOpertaionQueue for processing playlists
        // Add playlist processing object to the queue
        // ---- QUEUE should process one playlist at a time ---- 
        // QUEUE PROCESSING:
            // Get playlist details + create playlist
            // store playlist details on disk as json
            // Inject playlist guid into storybox's processing list
            // Inform storybox's delegate of new playlist
            // Create audio downloads for playlist and them to the audio downloads runner queue.
            // Use storybox's delegate playlist processing progress view to showcase progress for playlist audio downloads
            // kick off downloads
            // when audio downloads complete clear queue
        // Start processing next playlist until interrupted or all playlists complete.
    
    NSLog(@"Kicking off Playlists Download!");
    
    _playlistsProcessingQueue = [[NSOperationQueue alloc] init];
    
    [_playlistsProcessingQueue setMaxConcurrentOperationCount:1.0];
    
    __block NSInteger pendingGuids = [playlistGuids count];
    
    [playlistGuids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *guid = (NSString *)obj;
        PlaylistDownload *playlistDownload = [[[PlaylistDownload alloc]initWithStorybox:storybox playlistGuid:guid baseURL:_programmesAPIURL] autorelease];
        
        [_playlistsProcessingQueue addOperationWithBlock:^(void) {
            if ([playlistDownload getPlaylist]) {
                pendingGuids = pendingGuids - 1;
                if(pendingGuids == 0) [storybox finishedCollectingPlaylists];
            }
        }];
    }];
    [storybox startedCollectingPlaylists];
}

- (void)dealloc {
    [_programmesAPIURL release];
    [_remoteDataCache release];
    [_playlistsProcessingQueue release];
    [self.storybox release];
    [super dealloc];
}

@end
