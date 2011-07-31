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
    [_processingPlaylists release];
    [_tempPlaylistProcessing release];
    [self.playlistsQueue release];
    [self.playlistsCollectionDelegate release];
    [_storyboxManager release];
    [super dealloc];
}

+(NSString *)allPlaylistsPath{
    return [NSString stringWithFormat:@"%@/%@/%@", [FileStore applicationDocumentsDirectory], AUDIO_DIR, @"playlists"];
}

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue{
    self.playlistsQueue = playlistsQueue;
}

-(void)synchronizeWithLocalStorage{
    NSString *localPlaylistsPath = [Storybox allPlaylistsPath];
    
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    NSArray *localPlaylistGuids = [fileManager contentsOfDirectoryAtPath:localPlaylistsPath error:nil];
    
    if(localPlaylistGuids){
        _tempPlaylistProcessing = [NSMutableArray arrayWithCapacity:[localPlaylistGuids count]];
        
        [localPlaylistGuids enumerateObjectsUsingBlock:^(id guid, NSUInteger idx, BOOL *stop) {
            if(![guid isEqualToString:@".DS_Store"]){
                NSLog(@"Playlist guid: [%@]", guid);
                
                NSString *localJsonPath = [NSString stringWithFormat:@"%@/%@/%@.json", localPlaylistsPath, guid, guid];
                NSData *jsonContent = [fileManager contentsAtPath:localJsonPath];
                NSDictionary *dictionary = [jsonContent objectFromJSONData];
                Playlist *localPlaylist = [[Playlist alloc] initFromDictionary:dictionary];
                
                NSLog(@"localPlaylist date queued: [%@]", [[localPlaylist dateQueued] description]);
                NSLog(@"localPlaylist programmes count: [%d]", [[localPlaylist programmes] count]);
                NSLog(@"localPlaylist 1st programme title: [%@]", [[[localPlaylist programmes] objectAtIndex:1] title]);
                [localPlaylist release];
            }
        }];
        [self processLocalPlaylists];
    }
}

-(void)processLocalPlaylists{
}


-(NSString *)currentPlaylistsQueueGuid{
    return [self.playlistsQueue guid];
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

-(void)startCollectingPlaylistsUsingDelegate:(id)delegate{
    NSLog(@"Setting b4 kicking off collection!");
    
    self.playlistsCollectionDelegate = delegate;
    
    if(!_storyboxManager){
        _storyboxManager = [[StoryboxManager alloc] init];
    }
    
    [_storyboxManager appendPlaylistsToStorybox:self forGuids:[self playlistGuidsToCollect]];
}

-(void)startedCollectingPlaylists{
    [self.playlistsCollectionDelegate startedCollectingPlaylists];
}

-(void)finishedCollectingPlaylists{
    [self.playlistsCollectionDelegate finishedCollectingPlaylists];
}

@end
