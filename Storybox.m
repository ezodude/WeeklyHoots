//
//  Storybox.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 27/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Storybox.h"


@implementation Storybox

@synthesize playlistsQueue=_playlistsQueue;

- (void)dealloc {
    [_availablePlaylists release];
    [self.playlistsQueue release];
    [super dealloc];
}

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue{
    self.playlistsQueue = playlistsQueue;
        
    [self loadUpAvailablePlaylistsFromDisk];
    [self cleanUpExpiredPlaylists];
}

-(NSString *)nextPlaylistGuidToCollect{
    return nil;
}

-(void)loadUpAvailablePlaylistsFromDisk{
    
}

-(void)cleanUpExpiredPlaylists{
    
}

@end
