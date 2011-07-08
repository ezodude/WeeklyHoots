//
//  AudioDownload.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 06/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "FileStore.h"
#import "WeeklyBundle.h"
#import "Playlist.h"
#import "Programme.h"

@class ASIHTTPRequest;

#define AUDIO_DIR @"/Audio"

typedef void (^RequestFinishedCallbackBlock)();

@interface AudioDownload : NSObject {
    WeeklyBundle *_bundle;
    Playlist *_playlist;
    Programme *_programme;
    
    NSString *_downloadPath;
    NSString *_downloadFile;
    NSString *_tempDownloadFile;
}

@property (nonatomic, retain) WeeklyBundle *bundle;
@property (nonatomic, retain) Playlist *playlist;
@property (nonatomic, retain) Programme *programme;

@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSString *downloadFile;
@property (nonatomic, retain) NSString *tempDownloadFile;

@property (nonatomic, copy) RequestFinishedCallbackBlock requestFinishedCallbackBlock;

-(AudioDownload *)initWithBundle:(WeeklyBundle *)bundle playlist:(Playlist *)playlist programme:(Programme *)programme withRequestFinishedCallback:(RequestFinishedCallbackBlock)block;

-(ASIHTTPRequest *)generateRequest;
-(void)createDownloadPathOnDisk;
@end
