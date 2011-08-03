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
    [_tempPlaylistProcessing release];
    [_currentPlaylistsSlot release];
    [_olderPlaylistsSlot release];
    
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
    
    if(!localPlaylistGuids) return;
    
    _tempPlaylistProcessing = [NSMutableArray arrayWithCapacity:[localPlaylistGuids count]];
    
    [localPlaylistGuids enumerateObjectsUsingBlock:^(id guid, NSUInteger idx, BOOL *stop) {
        if(![guid isEqualToString:@".DS_Store"]){
            NSLog(@"Playlist guid: [%@]", guid);
            
            NSString *localJsonPath = [NSString stringWithFormat:@"%@/%@/%@.json", localPlaylistsPath, guid, guid];
            NSData *jsonContent = [fileManager contentsAtPath:localJsonPath];
            NSDictionary *dictionary = [jsonContent objectFromJSONData];
            Playlist *localPlaylist = [[Playlist alloc] initFromDictionary:dictionary];
            
            NSLog(@"localPlaylist date queued: [%@]", [[localPlaylist dateQueued] description]);
            NSLog(@"localPlaylist expiry date: [%@]", [[localPlaylist expiryDate] description]);
            
            [_tempPlaylistProcessing addObject:localPlaylist];
            [localPlaylist release];
        }
    }];
    
    [self processLocalPlaylists];
}

-(void)processLocalPlaylists{
    [self removeExpiredPlaylists];
    [self removePlaylistsWithIncompleteDownloads];
    [self partitionPlaylistsIntoSlots];
}

-(void)removeExpiredPlaylists{
    NSLog(@"**Before** Removing Expired content count is: [%d]", [_tempPlaylistProcessing count]);
    
    NSPredicate *isExpiredPredicate = 
    [NSPredicate predicateWithFormat:@"isExpired == YES"];
    
    NSArray *expiredPlaylists = [[NSArray arrayWithArray:_tempPlaylistProcessing] filteredArrayUsingPredicate:isExpiredPredicate];
    
    if([expiredPlaylists count] == 0){
        NSLog(@"Nothing Expired!!");
        return;
    }
    
    NSString *localPlaylistsPath = [Storybox allPlaylistsPath];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    
    [expiredPlaylists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Removing Expired object with guid: [%@]", [obj guid]);
        NSString *expiredPlaylistPath = [NSString stringWithFormat:@"%@/%@", localPlaylistsPath, [obj guid]];
        if ([fileManager removeItemAtPath:expiredPlaylistPath error:nil]) {
            [_tempPlaylistProcessing removeObject:obj];
        }
    }];
    
    NSLog(@"**After** Removing Expired content count is: [%d]", [_tempPlaylistProcessing count]);
}

-(void)removePlaylistsWithIncompleteDownloads{
    NSLog(@"**Before** Removing Incomplete Downloads count is: [%d]", [_tempPlaylistProcessing count]);
    
    NSPredicate *hasIncompleteDownloadsPredicate = 
    [NSPredicate predicateWithFormat:@"hasCompleteDownloads == YES"];    
    [_tempPlaylistProcessing filterUsingPredicate:hasIncompleteDownloadsPredicate];
    
    NSLog(@"**After** Removing Incomplete Downloads count is: [%d]", [_tempPlaylistProcessing count]);
}

-(void)partitionPlaylistsIntoSlots{
    __block NSMutableArray *currentSlot = [NSMutableArray arrayWithCapacity:[_tempPlaylistProcessing count]];
    
    __block NSMutableArray *olderSlot = [NSMutableArray arrayWithCapacity:[_tempPlaylistProcessing count]];
    
    [_tempPlaylistProcessing enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL isCurrent = [[obj dateQueued] isEqualToDate:[self.playlistsQueue startDate]];
        isCurrent ? [currentSlot addObject:obj] : [olderSlot addObject:obj];
    }];
    
    _currentPlaylistsSlot = [[NSArray arrayWithArray:currentSlot] retain];
    NSLog(@"_currentPlaylistsSlot: [%@]", [_currentPlaylistsSlot description]);
    
    _olderPlaylistsSlot = [[NSArray arrayWithArray:olderSlot] retain];
    NSLog(@"_olderPlaylistsSlot: [%@]", [_olderPlaylistsSlot description]);
}

-(NSString *)currentPlaylistsQueueGuid{
    return [self.playlistsQueue guid];
}

-(NSArray *)playlistGuidsToCollect{
    NSLog(@"_currentPlaylistsSlot: [%@]", [_currentPlaylistsSlot description]);
    
    NSMutableArray *availableGuids = [NSMutableArray arrayWithCapacity:[_currentPlaylistsSlot count]];
    [_currentPlaylistsSlot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [availableGuids addObject:[(Playlist *)obj guid]];
    }];
    
    NSMutableArray *pendingGuids = [NSMutableArray arrayWithCapacity:[[self.playlistsQueue playlistGuids] count]];
    [[self.playlistsQueue playlistGuids] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *guid = obj;
        if (![availableGuids containsObject:guid]) {
            [pendingGuids addObject:guid];
        }
    }];
    
    NSLog(@"Pending Guids: [%@]", pendingGuids);
    
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

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist{
    [self.playlistsCollectionDelegate addPlaylistUndergoingDownload:playlist];
}

-(void)finishedCollectingPlaylists{
    [self.playlistsCollectionDelegate finishedCollectingPlaylists];
}

@end
