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
@synthesize playlistsCollectionDelegate=_playlistsCollectionDelegate;

- (void)dealloc {
    [_availablePlaylists release];
    [self.playlistsQueue release];
    [self.playlistsCollectionDelegate release];
    [_storyboxManager release];
    [super dealloc];
}

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue{
    self.playlistsQueue = playlistsQueue;
        
    [self loadUpAvailablePlaylistsFromDisk];
    [self cleanUpExpiredPlaylists];
}

-(NSArray *)playlistGuidsToCollect{
    
    NSMutableArray *availableGuids = [NSMutableArray arrayWithCapacity:[_availablePlaylists count]];
    [_availablePlaylists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *guid = [(Playlist *)obj guid];
        [availableGuids addObject:guid];
    }];
    
    NSMutableArray *pendingGuids = [NSMutableArray arrayWithCapacity:[[self.playlistsQueue playlistGuids] count]];
    [[self.playlistsQueue playlistGuids] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *guid = obj;
        if (![availableGuids containsObject:guid]) {
            [pendingGuids addObject:guid];
        }
    }];
    return pendingGuids;
}

-(void)loadUpAvailablePlaylistsFromDisk{
    
}

-(void)cleanUpExpiredPlaylists{
    
}

-(void)startCollectingPlaylistsUsingDelegate:(id)delegate{
    self.playlistsCollectionDelegate = delegate;
    
    if(!_storyboxManager){
        _storyboxManager = [[StoryboxManager alloc] init];
    }
    
    [_storyboxManager appendPlaylistsToStorybox:self forGuids:[self playlistGuidsToCollect] ];
}

@end
