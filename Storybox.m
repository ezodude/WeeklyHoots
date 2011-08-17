//
//  Storybox.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 27/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Storybox.h"
#import "FileStoreSyncer.h"
#import "Playlist.h"
#import "FailedPlaylist.h"

@implementation Storybox

@synthesize playlistsQueue=_playlistsQueue;

@synthesize currentPlaylistsSlot=_currentPlaylistsSlot;
@synthesize olderPlaylistsSlot=_olderPlaylistsSlot;
@synthesize failedPlaylistsSlot=_failedPlaylistsSlot;
@synthesize playlistsErringDuringDownloads=_playlistsErringDuringDownloads;

@synthesize playlistsCollectionDelegate=_playlistsCollectionDelegate;
@synthesize collectionMode=_collectionMode;

- (void)dealloc {
    [_tempPlaylistProcessing release];
    
    [self.currentPlaylistsSlot release];
    [self.olderPlaylistsSlot release];
    [self.failedPlaylistsSlot release];
    [self.playlistsErringDuringDownloads release];
    
    [self.playlistsQueue release];
    [self.playlistsCollectionDelegate release];
    [_playlistDownload release];
    [_programmesAPIURL release];
    [super dealloc];
}

+(NSString *)allPlaylistsPath{
    return [NSString stringWithFormat:@"%@/%@/%@", [FileStore applicationDocumentsDirectory], AUDIO_DIR, @"playlists"];
}

+(NSString *)failedPlaylistsPath{
    return [NSString stringWithFormat:@"%@/%@/%@", [FileStore applicationDocumentsDirectory], AUDIO_DIR, @"failed-playlists"];
}

- (id)init {
    self = [super init];
    
    if (self) {
        _programmesAPIURL = [[[Environment sharedInstance] programmesAPIURL] retain];
        self.currentPlaylistsSlot = [NSArray array];
        self.olderPlaylistsSlot = [NSArray array];
        self.failedPlaylistsSlot = [NSArray array];
    }
    return self;
}

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue{
    self.playlistsQueue = playlistsQueue;
}

-(void)synchronizeWithLocalStorage{
    FileStoreSyncer *syncer = [[FileStoreSyncer alloc] initWithStorybox:self];

    [syncer extractPlaylists];
    [syncer deleteExpiredPlaylists];
    [syncer ignorePlaylistsWithIncompleteDownloads];
    [syncer categorisePlaylists];
    
    [syncer release];
}

-(NSString *)currentPlaylistsQueueGuid{
    return [self.playlistsQueue guid];
}

-(NSArray *)getGuidsToIgnoreFromCollection{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self.currentPlaylistsSlot count]];
    [self.currentPlaylistsSlot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[obj guid]];
    }];
    
    [self.failedPlaylistsSlot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[obj guid]];
    }];
    
    return result;
}

-(NSString *)nextPlaylistGuidToCollect{
    NSLog(@"self.currentPlaylistsSlot: [%@]", [self.currentPlaylistsSlot description]);
    
    NSMutableArray *guidsToCollect = [NSMutableArray arrayWithArray:[self.playlistsQueue playlistGuids]];
    [guidsToCollect removeObjectsInArray:[self getGuidsToIgnoreFromCollection]];
        
    NSLog(@"Guids To Collect: [%@]", guidsToCollect);
    return [guidsToCollect count] == 0 ? nil : [guidsToCollect objectAtIndex:0];
}

-(BOOL)allPlaylistsCollected{
    return [self nextPlaylistGuidToCollect] == nil;
}

-(void)collectPlaylistsUsingDelegate:(id)delegate{
    NSLog(@"Setting b4 kicking off collection!");
    
    if(!self.playlistsCollectionDelegate && !_collectionMode) 
        self.playlistsCollectionDelegate = delegate;
    
    NSString *playlistGuidToCollect = [self nextPlaylistGuidToCollect];
    if (playlistGuidToCollect) {
        _playlistDownload = [[[PlaylistDownload alloc]initWithStorybox:self playlistGuid:playlistGuidToCollect apiBaseURL:_programmesAPIURL] retain];
        
        [_playlistDownload getPlaylist];
                
        self.collectionMode = YES;
    }else{
        [self finishedCollectingPlaylists];
    }
}

-(void)stopCollectingPlaylists{
    if (self.collectionMode){
        [_playlistDownload stop];
        self.collectionMode = NO;
            
        [self.playlistsCollectionDelegate stopCollectingPlaylists];
    }
}

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist{
    [self.playlistsCollectionDelegate addPlaylistUndergoingDownload:playlist];
}

-(void)playlistCompletedDownloading:(Playlist *)playlist{
    NSLog(@"Playlist [%@] Completed Downloading!", [playlist title]);
    NSLog(@"Collection Mode! [%d]", self.collectionMode);
    
    NSMutableArray *newCurrentPlaylistsSlot = [NSMutableArray arrayWithArray:self.currentPlaylistsSlot];
    [newCurrentPlaylistsSlot insertObject:playlist atIndex:0];
    self.currentPlaylistsSlot = [NSArray arrayWithArray:newCurrentPlaylistsSlot];
    
    if(self.playlistsCollectionDelegate)
        [self.playlistsCollectionDelegate playlistCompletedDownloading:playlist];
    
    [_playlistDownload release];
    
    if (self.collectionMode) [self collectPlaylistsUsingDelegate:nil];
}

-(void)handleFailedPlaylist:(FailedPlaylist *)failedPlaylist{
    NSLog(@"!!!Handling Failed Playlist!!!");
    
    NSMutableArray *tempFailedPlaylists = [NSMutableArray arrayWithArray:self.failedPlaylistsSlot];
    [tempFailedPlaylists addObject:failedPlaylist];
    self.failedPlaylistsSlot = [NSArray arrayWithArray:tempFailedPlaylists];
    
    NSLog(@"self.failedPlaylistsSlot: [%@]", [self.failedPlaylistsSlot description]);
    
    [_playlistDownload release];
    
    if ([[failedPlaylist localizedErrorDescription] isEqualToString:@"A connection failure occurred"]){
        [self.playlistsCollectionDelegate playlistHasFailed:failedPlaylist];
        [self stopCollectingPlaylists];
    }else{
        if (self.collectionMode) [self collectPlaylistsUsingDelegate:nil];
    }
}

-(void)finishedCollectingPlaylists{
    NSLog(@"******FINISHED COLLECTING ALL PLAYLISTS******");
    
    self.collectionMode = NO;
    [self.playlistsCollectionDelegate finishedCollectingPlaylists];
}

@end
