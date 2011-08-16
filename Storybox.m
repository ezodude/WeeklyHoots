//
//  Storybox.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 27/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Storybox.h"
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
    }
    return self;
}

-(void)loadAndsetupWithPlaylistsQueue:(PlaylistsQueue *)playlistsQueue{
    self.playlistsQueue = playlistsQueue;
}

-(void)synchronizeWithLocalStorage{
    NSString *localPlaylistsPath = [Storybox allPlaylistsPath];
    NSString *localFailedPlaylistsPath = [Storybox failedPlaylistsPath];
    
    const int MinCapacity = 10;
    _tempPlaylistProcessing = [NSMutableArray arrayWithCapacity:MinCapacity];
    
    [self synchronizePlaylistsAtPath:localPlaylistsPath];
    [self synchronizePlaylistsAtPath:localFailedPlaylistsPath];
    
    NSLog(@"[_tempPlaylistProcessing count]: [%d]", [_tempPlaylistProcessing count]);
    if([_tempPlaylistProcessing count] > 0) [self processLocalPlaylists];
}

-(void)synchronizePlaylistsAtPath:(NSString *)path{
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    NSArray *localGuids = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    if(!localGuids) return;
    
    [localGuids enumerateObjectsUsingBlock:^(id guid, NSUInteger idx, BOOL *stop) {
        if(![guid isEqualToString:@".DS_Store"]){
            NSLog(@"Playlist guid: [%@]", guid);
            
            NSString *localJsonPath = [NSString stringWithFormat:@"%@/%@/%@.json", path, guid, guid];
            
            NSData *jsonContent = [fileManager contentsAtPath:localJsonPath];
            NSDictionary *dictionary = [jsonContent objectFromJSONData];
            
            id localPlaylist = nil;
            
            if ([dictionary objectForKey:@"error"])
                localPlaylist = [[FailedPlaylist alloc] initFromDictionary:dictionary];
            else
                localPlaylist = [[Playlist alloc] initFromDictionary:dictionary];
            
            [_tempPlaylistProcessing addObject:localPlaylist];
            [localPlaylist release];
        }
    }];
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
    
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    
    [expiredPlaylists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Removing Expired object with guid: [%@]", [obj guid]);

        if ([fileManager removeItemAtPath:[obj pathOnDisk] error:nil]) {
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
    self.failedPlaylistsSlot = [_tempPlaylistProcessing filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasErrors == YES"]];
    NSLog(@"self.failedPlaylistsSlot: [%@]", [self.failedPlaylistsSlot description]);
    
    [_tempPlaylistProcessing filterUsingPredicate:[NSPredicate predicateWithFormat:@"hasErrors == NO"]];
    
    __block NSMutableArray *currentSlot = [NSMutableArray arrayWithCapacity:[_tempPlaylistProcessing count]];
    
    __block NSMutableArray *olderSlot = [NSMutableArray arrayWithCapacity:[_tempPlaylistProcessing count]];
        
    [_tempPlaylistProcessing enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL isCurrent = [[obj dateQueued] isEqualToDate:[self.playlistsQueue startDate]];
        isCurrent ? [currentSlot addObject:obj] : [olderSlot addObject:obj];
    }];
    
    self.currentPlaylistsSlot = [NSArray arrayWithArray:currentSlot];
    NSLog(@"self.currentPlaylistsSlot: [%@]", [self.currentPlaylistsSlot description]);
    
    self.olderPlaylistsSlot = [NSArray arrayWithArray:olderSlot];
    NSLog(@"self.olderPlaylistsSlot: [%@]", [self.olderPlaylistsSlot description]);
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

-(void)playlistErredWhileDownloading:(Playlist *)playlist error:(NSError *)error{
    NSLog(@"Playlist [%@] Erred While Downloading!, error: [%@]", [playlist guid], [error description]);

    if (!self.playlistsErringDuringDownloads) {
        self.playlistsErringDuringDownloads = [NSArray arrayWithObject:playlist];
    }else{
        NSMutableArray *tempErringPlaylists = [NSMutableArray arrayWithArray:self.playlistsErringDuringDownloads];
        
        [tempErringPlaylists addObject:playlist];
        self.playlistsErringDuringDownloads = [NSArray arrayWithArray:tempErringPlaylists];
    }    
    
    [_playlistDownload release];
    
    if (self.collectionMode) [self collectPlaylistsUsingDelegate:nil];
}


-(void)handleFailedPlaylist:(FailedPlaylist *)failedPlaylist{
    NSLog(@"!!!Handling Failed Playlist!!!");
}

-(void)finishedCollectingPlaylists{
    NSLog(@"******FINISHED COLLECTING ALL PLAYLISTS******");
    
    self.collectionMode = NO;
    [self.playlistsCollectionDelegate finishedCollectingPlaylists];
}

@end
