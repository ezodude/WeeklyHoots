//
//  StoryboxFileStoreSynchronizer.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 16/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileStore.h"

@class Storybox;
@class Playlist;
@class FailedPlaylist;

@interface FileStoreSyncer : NSObject {
    Storybox *_storybox;
    NSMutableArray *_playlistsUnderProcess;
}

@property (nonatomic, retain) Storybox *storybox;
@property (nonatomic, retain) NSMutableArray *playlistsUnderProcess;

-(id)initWithStorybox:(Storybox *)storybox;

-(void)extractPlaylists;
-(void)extractPlaylistsAtPath:(NSString *)path;
-(void)deleteExpiredPlaylists;
-(void)ignorePlaylistsWithIncompleteDownloads;
-(void)categorisePlaylists;

@end
