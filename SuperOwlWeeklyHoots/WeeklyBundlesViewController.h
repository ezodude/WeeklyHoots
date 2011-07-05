//
//  WeeklyBundlesViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 04/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeeklyBundle.h"

@interface WeeklyBundlesViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate> {
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

@property (nonatomic, retain) IBOutlet UISegmentedControl *currentOrRecentBundleControl;
@property (nonatomic, retain) IBOutlet UILabel *startWeekDayNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *endWeekDayNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDayDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endDayDateLabel;

@property (nonatomic, retain) IBOutlet UILabel *bundleDurationLabel;
@property (nonatomic, retain) IBOutlet UILabel *syncedDurationLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *bundleSyncStatusBar;

@property (nonatomic, retain) IBOutlet UITableView *playlistsMenu;

@property (nonatomic, retain) IBOutlet UIButton *syncButton;
@property (nonatomic, retain) IBOutlet UIButton *listenButton;

-(IBAction)toggleControls:(id)sender;
-(void)drawViewUsingBundle:(WeeklyBundle *)bundle;
-(void)drawButtons;

@end
