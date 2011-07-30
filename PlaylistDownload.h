//
//  PlaylistDownload.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 30/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileStore.h"
#import "Storybox.h"
#import "Playlist.h"
#import "Environment.h"

#import "ASIHTTPRequest.h"

@class Storybox;

#define AUDIO_DIR @"/Audio"

@interface PlaylistDownload : NSObject {
    NSString *_programmesAPIURL;
    Storybox *_storybox;
    NSString *_playlistGuid;
    
    NSString *_downloadPath;
    NSString *_downloadFile;
    NSString *_tempDownloadFile;
}

@property (nonatomic, retain) NSString *programmesAPIURL;
@property (nonatomic, retain) Storybox *storybox;
@property (nonatomic, retain) NSString *playlistGuid;

@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSString *downloadFile;
@property (nonatomic, retain) NSString *tempDownloadFile;

+(NSString *)downloadPathUsingPlaylistsQueueGuid:(NSString *)queueGuid playlistGuid:(NSString *)playlistGuid;
+(NSString *)playlistJsonFilename:(NSString *)playlistGuid;

-(id)initWithStorybox:(Storybox *)storybox playlistGuid:(NSString *)playlistGuid baseURL:(NSString *)baseURL;
-(BOOL)getPlaylist;
-(void)createDownloadPathOnDisk;
@end
