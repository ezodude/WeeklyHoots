    //
//  Storybox.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 27/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "StoryboxLoader.h"
#import "PlaylistsQueue.h"
#import "FileStore.h"

@class StoryboxLoader;
@class FileStoreSyncer;
@class PlaylistDownload;
@class Playlist;

@class Reachability;

typedef enum {
    SuperOwlPlaylistProgramme404
} SuperOwlNetworkErrorType;

extern NSString* const SuperOwlNetworkErrorDomain;

@interface Storybox : NSObject {
    NSString *_programmesAPIURL;
    
    PlaylistsQueue *_playlistsQueue;
    
    NSMutableArray *_tempPlaylistProcessing;
    NSArray *_currentPlaylistsSlot;
    NSArray *_olderPlaylistsSlot;
    NSArray *_ignoredPlaylists;
    
    BOOL _collectionMode;
    PlaylistDownload *_playlistDownload;
    id _playlistsCollectionDelegate;
    
    Reachability *_internetReachable;
    BOOL _wifiConnected;
}

@property (nonatomic, retain) PlaylistsQueue *playlistsQueue;

@property (nonatomic, retain) NSArray *currentPlaylistsSlot;
@property (nonatomic, retain) NSArray *olderPlaylistsSlot;
@property (nonatomic, retain) NSArray *ignoredPlaylists;

@property (nonatomic, retain) id playlistsCollectionDelegate;
@property (nonatomic, assign) BOOL collectionMode;

+(NSString *)allPlaylistsPath;

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue;

-(void)synchronizeWithLocalStorage;

-(NSString *)currentPlaylistsQueueGuid;

-(BOOL)allPlaylistsCollected;
-(NSArray *)getGuidsToIgnoreFromCollection;
-(NSString *)nextPlaylistGuidToCollect;

-(void)collectPlaylistsUsingDelegate:(id)delegate;
-(void)stopCollectingPlaylists;

-(void)finishedCollectingPlaylists;

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist;
-(void)playlistCompletedDownloading:(Playlist *)playlist;

-(void)handleFailedPlaylist:(Playlist *)playlist erorrMsg:(NSString *)msg abortCollection:(BOOL)shouldAbort ignorePlayList:(BOOL)shouldIgnore;

-(void)checkWifiNetworkStatus:(NSNotification *)notice;
-(BOOL)isWifiConnected;
@end
