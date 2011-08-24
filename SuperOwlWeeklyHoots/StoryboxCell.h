//
//  StoryboxCell.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Playlist;

@interface StoryboxCell : UITableViewCell {
    BOOL _isReady;
    Playlist *_sourcePlaylist;
    UIProgressView *_progressView;
    
    UIImageView *_currentStateImage;
    UILabel *_playlistTitle;
    UILabel *_storyJockeyCaption;
    UILabel *_storyJockeyName;
    UILabel *_daysRemaining;
}

@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, retain) Playlist *sourcePlaylist;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@property (nonatomic, retain) IBOutlet UIImageView *currentStateImage;
@property (nonatomic, retain) IBOutlet UILabel *playlistTitle;
@property (nonatomic, retain) IBOutlet UILabel *storyJockeyCaption;
@property (nonatomic, retain) IBOutlet UILabel *storyJockeyName;
@property (nonatomic, retain) IBOutlet UILabel *daysRemaining;

-(void)setupPlaylist:(Playlist *)playlist;
-(void)configureReadiness;
@end
