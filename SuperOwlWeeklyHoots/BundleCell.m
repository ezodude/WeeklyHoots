//
//  BundleCell.m
//  BundlesCustomTableView
//
//  Created by Abdel Saleh on 15/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "BundleCell.h"

@implementation BundleCell

@synthesize baseView;
@synthesize bundleDetailsBackgroundImage=_bundleDetailsBackgroundImage;

@synthesize startDate=_startDate;
@synthesize audioStoriesSyncedCount=_audioStoriesSyncedCount;
@synthesize listeningHoursTotal=_listeningHoursTotal;
@synthesize syncButton=_syncButton;
@synthesize playButton=_playButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setupWithBackgroundImage:(NSString *)imagePath startDate:(NSString *)startDate listeningHoursTotal:(NSString *)listeningHoursTotal audioStoriesSyncedCount:(NSString *)audioStoriesSyncedCount{
    [self setupBundleBackgroundImage:imagePath];
    [self setupButtons];
    [self setupLabelsForStartDate:startDate listeningHoursTotal:listeningHoursTotal audioStoriesSyncedCount:audioStoriesSyncedCount];
}

-(void)setupBundleBackgroundImage:(NSString *)imagePath{
    static int ContentViewWidth = 280;
    static int BackgroundImageTargetHeight = 146;
    
    UIImage *image = [UIImage imageNamed:imagePath];
    
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(ContentViewWidth, image.size.height) interpolationQuality:kCGInterpolationHigh];
    
    image = [image croppedImage:CGRectMake(0, 0, ContentViewWidth, BackgroundImageTargetHeight)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    [imageView.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    [imageView.layer setBorderWidth:2.0];
    [imageView setContentMode:UIViewContentModeCenter];
    
    self.bundleDetailsBackgroundImage = imageView;
    
    [self.baseView addSubview:self.bundleDetailsBackgroundImage];
    [self.baseView sendSubviewToBack:self.bundleDetailsBackgroundImage];
    
    [imageView release];
}

-(void)setupButtons{
    [self.syncButton setImage:[UIImage imageNamed:@"sync-normal.png"] forState:UIControlStateNormal];
    
    [self.syncButton setImage:[UIImage imageNamed:@"sync-highlight.png"] forState:UIControlStateHighlighted];
}

-(void)setupLabelsForStartDate:(NSString *)startDate listeningHoursTotal:(NSString *)listeningHoursTotal audioStoriesSyncedCount:(NSString *)audioStoriesSyncedCount{
    self.startDate.text = startDate;
    self.listeningHoursTotal.text = listeningHoursTotal;
    self.audioStoriesSyncedCount.text = audioStoriesSyncedCount;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [self.baseView release];
    [self.bundleDetailsBackgroundImage release];
    
    [self.startDate release];
    [self.audioStoriesSyncedCount release];
    [self.listeningHoursTotal release];
    [self.syncButton release];
    [self.playButton release];
    
    [super dealloc];
}

@end
