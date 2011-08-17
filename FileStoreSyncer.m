//
//  StoryboxFileStoreSynchronizer.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 16/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "FileStoreSyncer.h"
#import "Storybox.h"
#import "Playlist.h"
#import "FailedPlaylist.h"

@implementation FileStoreSyncer

@synthesize storybox=_storybox;
@synthesize playlistsUnderProcess=_playlistsUnderProcess;

-(id)initWithStorybox:(Storybox *)storybox{
    self = [super init];
    if (self) {
        self.storybox = storybox;
        self.playlistsUnderProcess = [NSMutableArray array];
    }
    return self;
}

-(void)extractPlaylists{
    NSString *localPlaylistsPath = [Storybox allPlaylistsPath];
    NSString *localFailedPlaylistsPath = [Storybox failedPlaylistsPath];
    
    [self extractPlaylistsAtPath:localPlaylistsPath];
    [self extractPlaylistsAtPath:localFailedPlaylistsPath];
    
    NSLog(@"self.playlistsUnderProcess count is: [%d]", [self.playlistsUnderProcess count]);
}

-(void)extractPlaylistsAtPath:(NSString *)path{
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
            
            [self.playlistsUnderProcess addObject:localPlaylist];
            [localPlaylist release];
        }
    }];

}

-(void)deleteExpiredPlaylists{
    if([self.playlistsUnderProcess count] == 0) return;
    
    NSLog(@"**Before** Removing Expired content count is: [%d]", [self.playlistsUnderProcess count]);
    
    NSPredicate *isExpiredPredicate = 
    [NSPredicate predicateWithFormat:@"isExpired == YES"];
    
    NSArray *expiredPlaylists = [self.playlistsUnderProcess filteredArrayUsingPredicate:isExpiredPredicate];
    
    if([expiredPlaylists count] == 0){
        NSLog(@"Nothing Expired!!");
        return;
    }
    
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    [expiredPlaylists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Removing Expired object with guid: [%@]", [obj guid]);
        
        if ([fileManager removeItemAtPath:[obj pathOnDisk] error:nil]) {
            [self.playlistsUnderProcess removeObject:obj];
        }
    }];
    
    NSLog(@"**After** Removing Expired content count is: [%d]", [self.playlistsUnderProcess count]);
}

-(void)ignorePlaylistsWithIncompleteDownloads{
    if([self.playlistsUnderProcess count] == 0) return;
    
    NSLog(@"**Before** Removing Incomplete Downloads count is: [%d]", [self.playlistsUnderProcess count]);
    
    NSPredicate *keepCompleteDownloadsPredicate = 
    [NSPredicate predicateWithFormat:@"hasCompleteDownloads == YES"];    
    [self.playlistsUnderProcess filterUsingPredicate:keepCompleteDownloadsPredicate];
    
    NSLog(@"**After** Removing Incomplete Downloads count is: [%d]", [self.playlistsUnderProcess count]);
}

-(void)categorisePlaylists{
    if([self.playlistsUnderProcess count] == 0) return;
    
    self.storybox.failedPlaylistsSlot = [self.playlistsUnderProcess filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hasErrors == YES"]];
    NSLog(@"self.storybox.failedPlaylistsSlot: [%@]", [self.storybox.failedPlaylistsSlot description]);
    
    [self.playlistsUnderProcess filterUsingPredicate:[NSPredicate predicateWithFormat:@"hasErrors == NO"]];
    
    __block NSMutableArray *currentSlot = [NSMutableArray arrayWithCapacity:[self.playlistsUnderProcess count]];
    
    __block NSMutableArray *olderSlot = [NSMutableArray arrayWithCapacity:[self.playlistsUnderProcess count]];
    
    [self.playlistsUnderProcess enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL isCurrent = [[obj dateQueued] isEqualToDate:[self.storybox.playlistsQueue startDate]];
        isCurrent ? [currentSlot addObject:obj] : [olderSlot addObject:obj];
    }];
    
    self.storybox.currentPlaylistsSlot = [NSArray arrayWithArray:currentSlot];
    NSLog(@"self.storybox.currentPlaylistsSlot: [%@]", [self.storybox.currentPlaylistsSlot description]);
    
    self.storybox.olderPlaylistsSlot = [NSArray arrayWithArray:olderSlot];
    NSLog(@"self.storybox.olderPlaylistsSlot: [%@]", [self.storybox.olderPlaylistsSlot description]);
}

- (void)dealloc {
    [self.storybox release];
    [self.playlistsUnderProcess release];
    [super dealloc];
}

@end
