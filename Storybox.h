    //
//  Storybox.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 27/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryboxManager.h"
#import "PlaylistsQueue.h"
#import "Playlist.h"
#import "FileStore.h"

@class StoryboxManager;
@class Playlist;

@interface Storybox : NSObject {
    PlaylistsQueue *_playlistsQueue;
    
    NSMutableArray *_tempPlaylistProcessing;
    NSArray *_currentPlaylistsSlot;
    NSArray *_olderPlaylistsSlot;
    
    BOOL _collectionMode;
    StoryboxManager *_storyboxManager;
    id _playlistsCollectionDelegate;
}

@property (nonatomic, retain) PlaylistsQueue *playlistsQueue;
@property (nonatomic, retain) id playlistsCollectionDelegate;
@property (nonatomic, assign) BOOL collectionMode;

+(NSString *)allPlaylistsPath;

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue;

-(void)synchronizeWithLocalStorage;
-(void)processLocalPlaylists;
-(void)removeExpiredPlaylists;
-(void)removePlaylistsWithIncompleteDownloads;
-(void)partitionPlaylistsIntoSlots;

-(NSString *)currentPlaylistsQueueGuid;

-(NSString *)nextPlaylistGuidToCollect;

-(void)collectPlaylistsUsingDelegate:(id)delegate;
-(void)startedCollectingPlaylists;
-(void)finishedCollectingPlaylists;

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist;
-(void)playlistCompletedDownloading:(Playlist *)playlist;
@end
