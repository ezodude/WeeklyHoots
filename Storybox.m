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
#import "Reachability.h"

NSString* const SuperOwlNetworkErrorDomain = @"SuperOwlNetworkErrorDomain";

@implementation Storybox

@synthesize playlistsQueue=_playlistsQueue;

@synthesize currentPlaylistsSlot=_currentPlaylistsSlot;
@synthesize olderPlaylistsSlot=_olderPlaylistsSlot;
@synthesize ignoredPlaylists=_ignoredPlaylists;

@synthesize playlistsCollectionDelegate=_playlistsCollectionDelegate;
@synthesize collectionMode=_collectionMode;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_wifiReachable release];
    
    [_tempPlaylistProcessing release];
    
    [self.currentPlaylistsSlot release];
    [self.olderPlaylistsSlot release];
    [self.ignoredPlaylists release];
    
    [self.playlistsQueue release];
    [self.playlistsCollectionDelegate release];
    
    [_playlistDownload release];
    [_programmesAPIURL release];
    
    [super dealloc];
}

+(NSString *)allPlaylistsPath{
    return [NSString stringWithFormat:@"%@/%@/%@", [FileStore applicationDocumentsDirectory], AUDIO_DIR, @"playlists"];
}

- (id)init {
    self = [super init];
    
    if (self) {
        _programmesAPIURL = [[[Environment sharedInstance] programmesAPIURL] retain];
        self.currentPlaylistsSlot = [NSArray array];
        self.olderPlaylistsSlot = [NSArray array];
        self.ignoredPlaylists = [NSArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkWifiNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        _wifiReachable = [[Reachability reachabilityForLocalWiFi] retain];
        [_wifiReachable startNotifier];
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
    
    [self.ignoredPlaylists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    
    if (![self isWifiConnected]) {
        [self handleFailedPlaylist:nil erorrMsg:@"Sorry, you have to be on wifi to pull audio stories." abortCollection:YES ignorePlayList:NO];
        return;
    }
    
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
    [_playlistDownload stop];
    self.collectionMode = NO;
        
    [self.playlistsCollectionDelegate stopCollectingPlaylists];
}

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist{
    [self.playlistsCollectionDelegate addPlaylistUndergoingDownload:playlist];
}

-(void)setProgress:(float)amount{
    [self.playlistsCollectionDelegate setProgress:amount];
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

-(void)handleFailedPlaylist:(Playlist *)playlist erorrMsg:(NSString *)msg abortCollection:(BOOL)shouldAbort ignorePlayList:(BOOL)shouldIgnore{
    NSLog(@"!!!Handling Failed Playlist!!!");
        
    if (_playlistDownload) [_playlistDownload release];
    
    [self.playlistsCollectionDelegate playlistHasFailed:playlist errorMsg:msg abortCollection:shouldAbort];
    
    if (playlist && shouldIgnore) {
        NSMutableArray *toIgnore = [NSMutableArray arrayWithArray:self.ignoredPlaylists];
        [toIgnore addObject:playlist];
        
        self.ignoredPlaylists = toIgnore;
    }
    
    if(playlist && shouldAbort){
        [self stopCollectingPlaylists];
    }else if(shouldAbort){
        [self.playlistsCollectionDelegate resetCollectionState];
    }else{
        [self collectPlaylistsUsingDelegate:nil];
    }
//    shouldAbort ? [self stopCollectingPlaylists] : [self collectPlaylistsUsingDelegate:nil];
}

-(void)finishedCollectingPlaylists{
    NSLog(@"******FINISHED COLLECTING ALL PLAYLISTS******");
    
    self.collectionMode = NO;
    [self.playlistsCollectionDelegate finishedCollectingPlaylists];
}

-(void)checkWifiNetworkStatus:(NSNotification *)notice{
    NetworkStatus internetStatus = [_wifiReachable currentReachabilityStatus];
    _wifiConnected = (internetStatus == ReachableViaWiFi);
}

-(BOOL)isWifiConnected{
    return [_wifiReachable isReachableViaWiFi];
}
@end
