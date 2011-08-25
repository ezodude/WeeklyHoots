//
//  PlaylistDetailsViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 22/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Playlist;
@class Programme;

@interface PlaylistDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    Playlist *_sourcePlaylist;
    
    UILabel *_playlistTitle;
    UILabel *_storyJockeyName;
    UIImageView *_storyJockeyImageView;
    UILabel *_daysRemaining;
    UITableView *_summaryAndProgsTableView;
}

@property (nonatomic, retain) Playlist *sourcePlaylist;

@property (nonatomic, retain) IBOutlet UILabel *playlistTitle;
@property (nonatomic, retain) IBOutlet UILabel *storyJockeyName;
@property (nonatomic, retain) IBOutlet UIImageView *storyJockeyImageView;
@property (nonatomic, retain) IBOutlet UILabel *daysRemaining;
@property (nonatomic, retain) IBOutlet UITableView *summaryAndProgsTableView;

-(CGFloat)RAD_textHeightForText:(NSString *)text systemFontOfSize:(CGFloat)size;
@end
