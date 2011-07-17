//
//  BundleCell.h
//  BundlesCustomTableView
//
//  Created by Abdel Saleh on 15/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

@interface BundleCell : UITableViewCell {
    UIView *_baseView;
    UIImageView *_bundleDetailsBackgroundImage;
    
    UILabel *_startDate;
    UILabel *_audioStoriesSyncedCount;
    UILabel *_listeningHoursTotal;
    
    UIButton *_syncButton;
    UIButton *_playButton;
}

@property (nonatomic, retain) IBOutlet UIView *baseView;
@property (nonatomic, retain) IBOutlet UIImageView *bundleDetailsBackgroundImage;

@property (nonatomic, retain) IBOutlet UILabel *startDate;
@property (nonatomic, retain) IBOutlet UILabel *audioStoriesSyncedCount;
@property (nonatomic, retain) IBOutlet UILabel *listeningHoursTotal;
@property (nonatomic, retain) IBOutlet UIButton *syncButton;
@property (nonatomic, retain) IBOutlet UIButton *playButton;

-(void)setupWithBackgroundImage:(NSString *)imagePath startDate:(NSString *)startDate listeningHoursTotal:(NSString *)listeningHoursTotal audioStoriesSyncedCount:(NSString *)audioStoriesSyncedCount;
-(void)setupBundleBackgroundImage:(NSString *)imagePath;
-(void)setupButtons;
-(void)setupLabelsForStartDate:(NSString *)startDate listeningHoursTotal:(NSString *)listeningHoursTotal audioStoriesSyncedCount:(NSString *)audioStoriesSyncedCount;

@end
