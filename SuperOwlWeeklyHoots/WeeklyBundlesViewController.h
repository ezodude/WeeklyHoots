//
//  WeeklyBundlesViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 04/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BundlesManager.h"
#import "Reachability.h"
#import "AudioDownloadsManager.h"

#import "MBProgressHUD.h"
#import "WeeklyBundlesNavController.h"
#import "BundleCell.h"

#define kSwitchesSegmentIndex	0

@class Reachability;
@class AudioDownloadsManager;

@interface WeeklyBundlesViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate> {
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_recentBundle;
    WeeklyBundle *_activeBundle;
    
    Reachability *_internetReachable;
    BOOL _wifiConnected;
    
    AudioDownloadsManager *_audioDownloadsManager;
    
    MBProgressHUD *_syncProgressStatus;
    
    UIButton *_syncButton;
    UIButton *_listenButton;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *recentBundle;
@property (nonatomic, retain) WeeklyBundle *activeBundle;

@property (nonatomic, retain) IBOutlet UITableView *bundlesTable;

@property (nonatomic, retain) IBOutlet MBProgressHUD *syncProgressStatus;

@property (nonatomic, retain) IBOutlet UIButton *syncButton;
@property (nonatomic, retain) IBOutlet UIButton *listenButton;

-(void)checkNetworkStatus:(NSNotification *)notice;


-(IBAction)processSyncing:(id)sender;
-(void)startSyncing:(UIButton *)button;
-(void)pauseSyncing:(UIButton *)button;
-(void)resumeSyncing:(UIButton *)button;
-(void)signalSyncCompleted;

-(void)loadDataUsingProgressIndicator:(MBProgressHUD *)progressIndicator;
-(void)flagLackOfWifiConnection;
-(void)syncUsingProgressView:(MBProgressHUD *)progressView;

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator;

@end
