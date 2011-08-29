//
//  StoryboxViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "StoryboxNavController.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

#import "MDAudioFile.h"
#import "MDAudioPlayerController.h"

@class StoryboxLoader;
@class StoryboxNavController;
@class PlaylistDetailsController;
@class Storybox;
@class Playlist;
@class MDAudioFile;
@class MDAudioPlayerController;

@interface StoryboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    StoryboxNavController *_navController;
    PlaylistDetailsController *_detailsController;
    
    UIImageView *_storyboxImageView;
    UILabel *_startDateDayLabel;
    UILabel *_startDateMonthYearLabel;
    UILabel *_storyboxPlaylistsQueueCount;
    UILabel *_storyboxPlaylistsCollectedCount;

    UIButton *_collectPlaylistsButton;
    UILabel *_collectPlaylistsButtonCaption;
    
    UIImageView *_introBackgroundImage;
    UITableView *_allPlaylistsTableView;
    
    Storybox *_storybox;
    NSArray *_storyboxCurrentPlaylists;
    NSArray *_storyboxOlderPlaylists;
    
    BOOL _isPlayerOn;
}

@property (nonatomic, retain) StoryboxNavController *navController;

@property (nonatomic, retain) IBOutlet UIImageView *storyboxImageView;
@property (nonatomic, retain) IBOutlet UILabel *startDateDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDateMonthYearLabel;
@property (nonatomic, retain) IBOutlet UILabel *storyboxPlaylistsQueueCount;
@property (nonatomic, retain) IBOutlet UILabel *storyboxPlaylistsCollectedCount;

@property (nonatomic, retain) IBOutlet UIButton *collectPlaylistsButton;
@property (nonatomic, retain) IBOutlet UILabel *collectPlaylistsButtonCaption;

@property (nonatomic, retain) IBOutlet UIImageView *introBackgroundImage;
@property (nonatomic, retain) IBOutlet UITableView *allPlaylistsTableView;

@property (nonatomic, retain) NSArray *storyboxCurrentPlaylists;
@property (nonatomic, retain) NSArray *storyboxOlderPlaylists;

@property (nonatomic, assign) BOOL isPlayerOn;

-(void)loadLatestStoryboxContent;
-(void)loadStoryboxImage;
-(void)configureCollectionButton;
-(void)loadStoryboxDateLabel;
-(void)loadStoryboxCollectionLabels;
-(void)loadStoryboxPlaylists;
-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator;

-(IBAction)collectPlaylists:(id)sender;
-(void)drawStopCollectionState;
-(void)drawStartCollectionState;

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist;
-(void)setProgress:(float)amount;
-(void)playlistCompletedDownloading:(Playlist *)playlist;

-(void)playlistHasFailed:(Playlist *)playlist errorMsg:(NSString *)msg abortCollection:(BOOL)shouldAbort;

-(void)finishedCollectingPlaylists;

-(void)stopCollectingPlaylists;
-(void)resetCollectionState;
@end
