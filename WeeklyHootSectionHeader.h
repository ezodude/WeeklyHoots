//
//  WeeklyHootSectionHeader.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 21/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperOwlAudioNotifications.h"

@interface WeeklyHootSectionHeader : UIView {
    UILabel *_startToEndDateLabel;
    UILabel *_durationLabel;
    UIButton *_syncButton;
    UIButton *_playButton;
    UIViewController *_parentController;
}
@property (nonatomic, retain) IBOutlet UILabel *startToEndDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UIButton *syncButton;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) UIViewController *parentController;

-(IBAction)startSync:(id)sender;
-(IBAction)startPlayer:(id)sender;
@end
