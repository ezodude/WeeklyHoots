//
//  StoryboxCell.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "StoryboxCell.h"
#import "Playlist.h"

@implementation StoryboxCell

@synthesize isReady=_isReady;
@synthesize sourcePlaylist=_sourcePlaylist;
@synthesize progressView=_progressView;
@synthesize activityIndicator=_activityIndicator;

@synthesize currentStateImage=_currentStateImage;
@synthesize playlistTitle=_playlistTitle;
@synthesize storyJockeyCaption=_storyJockeyCaption;
@synthesize storyJockeyName=_storyJockeyName;
@synthesize daysRemaining=_daysRemaining;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupPlaylist:(Playlist *)playlist{
    self.sourcePlaylist = playlist;
    
    self.playlistTitle.text = self.sourcePlaylist.title;
    self.storyJockeyName.text = self.sourcePlaylist.storyJockey;
    
    NSString *daysRemaining = self.sourcePlaylist.numberOfDaysBeforeExpiry == 0 ? @"Last day" : [NSString stringWithFormat:@"%d days left", self.sourcePlaylist.numberOfDaysBeforeExpiry];
    self.daysRemaining.text = daysRemaining;
}
         
-(void)configureReadiness{
    self.isReady = [self.sourcePlaylist hasCompleteDownloads];
    
    if(self.isReady){
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        [self.progressView setHidden:YES];
        [self.activityIndicator stopAnimating];
        
        [self.storyJockeyCaption setHidden:NO];
        [self.storyJockeyName setHidden:NO];
        [self.daysRemaining setHidden:NO];
        self.currentStateImage.image = [UIImage imageNamed:@"circle-play"];
    }else{
        [self.progressView setHidden:NO];
        [self.activityIndicator startAnimating];
        
        [self.storyJockeyCaption setHidden:YES];
        [self.storyJockeyName setHidden:YES];
        [self.daysRemaining setHidden:YES];
        self.currentStateImage.image = [UIImage imageNamed:@"circle-o"];
    }
}

- (void)dealloc
{
    [self.sourcePlaylist release];
    [self.progressView release];
    [self.activityIndicator release];
    
    [self.currentStateImage release];
    [self.playlistTitle release];
    [self.storyJockeyCaption release];
    [self.storyJockeyName release];
    [self.daysRemaining release];
    
    [super dealloc];
}

@end
