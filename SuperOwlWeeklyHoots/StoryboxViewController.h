//
//  StoryboxViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "StoryboxManager.h"
#import "PlaylistsQueue.h"
#import "StoryboxNavController.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

@class StoryboxManager;
@class StoryboxNavController;

@interface StoryboxViewController : UIViewController {
    UIImageView *_storyboxImageView;
    UILabel *_startDateDayLabel;
    UILabel *_startDateMonthYearLabel;
    PlaylistsQueue *_storyboxContent;
}

@property (nonatomic, retain) IBOutlet UIImageView *storyboxImageView;
@property (nonatomic, retain) IBOutlet UILabel *startDateDayLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDateMonthYearLabel;

-(void)loadLatestStoryboxContent;
-(void)loadStoryboxImage;
-(void)loadStoryboxLabels;
-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator;
@end
