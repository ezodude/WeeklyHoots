//
//  WeeklyBundlesViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 04/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BundlesManager.h"
#import "AudioDownloadsManager.h"

#import "MBProgressHUD.h"
#import "WeeklyBundlesNavController.h"

#define kSwitchesSegmentIndex	0

@class AudioDownloadsManager;

@interface WeeklyBundlesViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate> {
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_recentBundle;
    WeeklyBundle *_activeBundle;
    
    AudioDownloadsManager *_audioDownloadsManager;
    
    UISegmentedControl *_currentOrRecentBundleControl;
    
    UILabel *_startWeekDayNameLabel;
    UILabel *_endWeekDayNameLabel;
    UILabel *_startDayDateLabel;
    UILabel *_endDayDateLabel;
    
    UILabel *_bundleDurationLabel;
    UILabel *_syncedDurationLabel;
    UIProgressView *_bundleSyncStatusBar;
    
    UITableView *_playlistsMenu;
    
    UIButton *_syncButton;
    UIButton *_listenButton;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *recentBundle;
@property (nonatomic, retain) WeeklyBundle *activeBundle;

@property (nonatomic, retain) IBOutlet UISegmentedControl *currentOrRecentBundleControl;
@property (nonatomic, retain) IBOutlet UILabel *startWeekDayNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *endWeekDayNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDayDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endDayDateLabel;

@property (nonatomic, retain) IBOutlet UILabel *bundleDurationLabel;
@property (nonatomic, retain) IBOutlet UILabel *syncedProgrammesLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *bundleSyncStatusBar;

@property (nonatomic, retain) IBOutlet UITableView *playlistsMenu;

@property (nonatomic, retain) IBOutlet UIButton *syncButton;
@property (nonatomic, retain) IBOutlet UIButton *listenButton;

-(IBAction)toggleControls:(id)sender;

-(IBAction)processSyncing:(id)sender;
-(void)startSyncing:(UIButton *)button;
-(void)pauseSyncing:(UIButton *)button;
-(void)resumeSyncing:(UIButton *)button;
-(void)signalSyncCompleted;

-(void)loadDataUsingProgressIndicator:(MBProgressHUD *)progressIndicator;
-(void)syncUsingProgressView:(UIProgressView *)progressView;

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator;
-(void)drawViewUsingBundle;
-(void)drawProgrammesSynced;
-(void)drawButtons;

@end
