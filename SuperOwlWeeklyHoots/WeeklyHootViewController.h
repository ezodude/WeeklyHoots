//
//  FirstViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 17/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WeeklyHootSectionHeader.h"
#import "ASIHTTPRequest.h"
#import "SuperOwlAudioNotifications.h"

@class WeeklyBundle;
@class WeeklyHootSectionHeader;

#define AUDIO_STASH_DIR @"/SuperOwl Audio Stash"

@interface WeeklyHootViewController : UITableViewController <SuperOwlAudioNotifications, AVAudioPlayerDelegate> {
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_lastBundle;
    BOOL _audioAvailable;
    AVAudioPlayer *_player;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *lastBundle;
@property (nonatomic, assign) BOOL audioAvailable;
@property (nonatomic, retain) AVAudioPlayer *player;

- (void)grabURLInBackground:(NSString *)urlPath;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

- (void)startSyncing;
- (NSString *)applicationDocumentsDirectory;
- (void)createAudioStashDirectoryIfUnavailable;
- (void)downloadCurrentBundleFirstPlaylistProgrammeIfUnavailableLocally;
- (void)markPlaylistAsDownloaded;

@end
