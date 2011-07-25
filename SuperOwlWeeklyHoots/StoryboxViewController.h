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
#import "StoryboxNavController.h"

@class StoryboxManager;
@class StoryboxNavController;

@interface StoryboxViewController : UIViewController {
    UIImageView *_storyboxImageView;
}

@property (nonatomic, retain) IBOutlet UIImageView *storyboxImageView;

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator;
@end
