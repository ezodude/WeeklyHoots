//
//  StoryboxViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "StoryboxLoader.h"
#import "PlaylistsQueue.h"
#import "StoryboxNavController.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

@class StoryboxLoader;
@class StoryboxNavController;

@interface StoryboxViewController : UIViewController {
    UIImageView *_storyboxImageView;
    UILabel *_startDateDayLabel;
    UILabel *_startDateMonthYearLabel;
    UILabel *_storyboxPlaylistsQueueCount;
    UILabel *_storyboxPlaylistsCollectedCount;

    UIButton *_collectPlaylistsButton;

    Storybox *_storybox;
}

@property (nonatomic, retain) IBOutlet UIImageView *storyboxImageView;
@property (nonatomic, retain) IBOutlet UILabel *startDateDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDateMonthYearLabel;
@property (nonatomic, retain) IBOutlet UILabel *storyboxPlaylistsQueueCount;
@property (nonatomic, retain) IBOutlet UILabel *storyboxPlaylistsCollectedCount;

@property (nonatomic, retain) IBOutlet UIButton *collectPlaylistsButton;

-(void)loadLatestStoryboxContent;
-(void)loadStoryboxImage;
-(void)configureCollectionButton;
-(void)loadStoryboxLabels;
-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator;

-(IBAction)collectPlaylists:(id)sender;
-(void)addPlaylistUndergoingDownload:(Playlist *)playlist;
-(void)finishedCollectingPlaylists;
@end
