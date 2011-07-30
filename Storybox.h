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

@class StoryboxManager;

@interface Storybox : NSObject {
    PlaylistsQueue *_playlistsQueue;
    NSMutableArray *_availablePlaylists;
    NSMutableArray *_processingPlaylists;
    
    StoryboxManager *_storyboxManager;
    id _playlistsCollectionDelegate;
}

@property (nonatomic, retain) PlaylistsQueue *playlistsQueue;
@property (nonatomic, retain) id playlistsCollectionDelegate;

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue;

-(NSString *)currentPlaylistsQueueGuid;

-(NSArray *)playlistGuidsToCollect;
-(void)loadUpAvailablePlaylistsFromDisk;
-(void)cleanUpExpiredPlaylists;

-(void)startCollectingPlaylistsUsingDelegate:(id)delegate;
-(void)startedCollectingPlaylists;
-(void)finishedCollectingPlaylists;
@end
