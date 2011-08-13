//
//  PlaylistDownload.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 30/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "PlaylistDownload.h"


@implementation PlaylistDownload

@synthesize programmesAPIURL=_programmesAPIURL;
@synthesize storybox=_storybox;
@synthesize playlistGuid=_playlistGuid;
@synthesize playlist=_playlist;

@synthesize downloadPath = _downloadPath;
@synthesize downloadFile = _downloadFile;


+(NSString *)downloadPathUsingPlaylistsQueueGuid:(NSString *)queueGuid playlistGuid:(NSString *)playlistGuid {
    return [NSString stringWithFormat:@"%@/%@/%@/%@", [FileStore applicationDocumentsDirectory], AUDIO_DIR, @"playlists", playlistGuid];
}

+(NSString *)playlistJsonFilename:(NSString *)playlistGuid {
    return [NSString stringWithFormat:@"%@.json", playlistGuid];
}

-(id)initWithStorybox:(Storybox *)storybox playlistGuid:(NSString *)playlistGuid apiBaseURL:(NSString *)apiBaseURL{
    self = [super init];
    if(self){
        self.programmesAPIURL = apiBaseURL;
        self.storybox = storybox;
        self.playlistGuid = playlistGuid;
        
        self.downloadPath = [PlaylistDownload downloadPathUsingPlaylistsQueueGuid:[self.storybox currentPlaylistsQueueGuid] playlistGuid:self.playlistGuid];
        
        self.downloadFile = [self.downloadPath stringByAppendingFormat:@"/%@", [PlaylistDownload playlistJsonFilename:self.playlistGuid]];
    }
    return self;
}

-(void)main{
    [self getPlaylist];
}

-(BOOL)getPlaylist{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@playlists/%@.json", self.programmesAPIURL, self.playlistGuid]];
    
    _request = [[ASIHTTPRequest requestWithURL:url] retain];
        
    [_request setStartedBlock:^{
        NSLog(@"Request starting!");
        [self createDownloadPathOnDisk];
    }];
    
    [_request setCompletionBlock:^{
        NSLog(@"Starting setCompletionBlock for Playlist [%@]", _playlistGuid);
        
        [self mapAndStorePlaylistFromRequest:_request];
        [self.storybox addPlaylistUndergoingDownload:self.playlist];
        [self downloadPlaylistProgrammes];
    }];
    
    [_request setFailedBlock:^{
        NSLog(@"Starting setFailedBlock");
        NSLog(@"ERROR: %@", [[_request error] description]);
    }];
    
    [_request startAsynchronous];
    
    return YES;
}

-(void)stop{
    [_request clearDelegatesAndCancel];
    if (_audioDownloadsQueue && ![_audioDownloadsQueue isSuspended])
        [_audioDownloadsQueue reset];
}

-(void)createDownloadPathOnDisk{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    [manager createDirectoryAtPath:self.downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(void)mapAndStorePlaylistFromRequest:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[responseString mutableObjectFromJSONString];
    
    NSString *storyJockey = [[dictionary objectForKey:@"curator"] objectForKey:@"firstname"];
    NSString *summary = [dictionary objectForKey:@"full_summary"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *dateQueuedAsString = [dateFormatter stringFromDate:[[self.storybox playlistsQueue] startDate]];
    
    [dateFormatter release];
    
    [dictionary setObject:dateQueuedAsString forKey:@"dateQueued"];
    [dictionary setObject:storyJockey forKey:@"storyJockey"];
    [dictionary setObject:summary forKey:@"summary"];
    
    Playlist *newPlaylist = [[Playlist alloc] initFromDictionary:dictionary];
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    [fileManager createFileAtPath:self.downloadFile contents:[newPlaylist JSONData] attributes:nil];
    
    self.playlist = newPlaylist;
    
    [newPlaylist release];
}

-(void)downloadPlaylistProgrammes{
    if (!_audioDownloadsQueue) {
        _audioDownloadsQueue = [[ASINetworkQueue alloc] init];
        
        [_audioDownloadsQueue setDelegate:self];
        [_audioDownloadsQueue setMaxConcurrentOperationCount:3];
        [_audioDownloadsQueue setShouldCancelAllRequestsOnFailure:NO];
        [_audioDownloadsQueue setQueueDidFinishSelector:@selector(allDownloadsCompleted)];
        [_audioDownloadsQueue setShouldCancelAllRequestsOnFailure:NO];
    }
    
    NSString *audioDownloadsPath = [self.playlist audioDownloadsPath];
    [[self.playlist programmes] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ProgrammeDownload *progDownload = [[[ProgrammeDownload alloc] initWithProgramme:(Programme *)obj downloadPath:audioDownloadsPath delegate:self] autorelease];
        
        if([progDownload hasNotBeenDownloaded])
            [_audioDownloadsQueue addOperation:[progDownload generateRequest]];
    }];
    [_audioDownloadsQueue go];
}

-(void)downloadErrorForProgrammeDownload:(ProgrammeDownload *)programmeDownload error:(NSError *)error{
    [self stop];
    [self.storybox playlistErredWhileDownloading:self.playlist error:error];
}

-(void)allDownloadsCompleted{
    NSLog(@"ALL DOWNLOADS COMPLETE!");
    [self.storybox playlistCompletedDownloading:self.playlist];
}

- (void)dealloc {
    [self.downloadPath release];
    [self.downloadFile release];
    
    [_request release];
    [_audioDownloadsQueue release];
    
    [self.playlist release];
    [self.playlistGuid release];
    [self.storybox release];
    [self.programmesAPIURL release];
    
    [super dealloc];
}

@end
