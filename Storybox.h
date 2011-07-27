    //
//  Storybox.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 27/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistsQueue.h"
#import "Playlist.h"

@interface Storybox : NSObject {
    PlaylistsQueue *_playlistsQueue;
    NSMutableArray *_availablePlaylists;
}

@property (nonatomic, retain) PlaylistsQueue *playlistsQueue;

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue;

-(NSString *)nextPlaylistGuidToCollect;
-(void)loadUpAvailablePlaylistsFromDisk;
-(void)cleanUpExpiredPlaylists;

@end
