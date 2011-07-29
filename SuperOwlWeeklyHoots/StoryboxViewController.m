//
//  StoryboxViewController.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "StoryboxViewController.h"


@implementation StoryboxViewController

@synthesize storyboxImageView=_storyboxImageView;
@synthesize startDateDayLabel=_startDateDayLabel;
@synthesize startDateMonthYearLabel=_startDateMonthYearLabel;
@synthesize storyboxPlaylistsQueueCount=_storyboxPlaylistsQueueCount;
@synthesize storyboxPlaylistsCollectedCount=_storyboxPlaylistsCollectedCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.storyboxImageView release];
    [self.startDateDayLabel release];
    [self.startDateMonthYearLabel release];
    [self.storyboxPlaylistsQueueCount release];
    [self.storyboxPlaylistsCollectedCount release];
    [_storybox release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self loadLatestStoryboxContent];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Refresh Storybox Content Methods

-(void)loadLatestStoryboxContent{
    StoryboxNavController *navController = [[[UIApplication sharedApplication] delegate] storyboxNavController];
    
    MBProgressHUD *HUD = [[MBProgressHUD showHUDAddedTo:navController.view animated:YES] retain];
    StoryboxManager *manager = [StoryboxManager manager];
    
    [manager setupStoryboxUsingProgressIndicator:HUD 
        WithCallback:^{
            _storybox = [manager storybox];
            [self loadStoryboxImage];
            [self loadStoryboxLabels];
            [self cleanUpProgressIndicator:HUD];
        }
     ];
}

-(void)loadStoryboxImage{
    static int ContentViewWidth = 320;
    static int BackgroundImageTargetHeight = 132;
    
    NSLog(@"Setting up image: [%@]", [[_storybox playlistsQueue] imageUri]);
    
    UIImage *image = [UIImage imageNamed:[[_storybox playlistsQueue] imageUri]];
    
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(ContentViewWidth, BackgroundImageTargetHeight ) interpolationQuality:kCGInterpolationHigh];
    
    image = [image croppedImage:CGRectMake(0, 0, ContentViewWidth, BackgroundImageTargetHeight)];
    
    [self.storyboxImageView setImage:image];
    [self.storyboxImageView.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    [self.storyboxImageView setContentMode:UIViewContentModeCenter];
}

-(void)loadStoryboxLabels{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"dd" options:0 locale:[NSLocale currentLocale]]];
    
    self.startDateDayLabel.text = [dateFormatter 
                                stringFromDate:[[_storybox playlistsQueue] startDate]];
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMYY" options:0 locale:[NSLocale currentLocale]]];
    self.startDateMonthYearLabel.text = [dateFormatter 
                                stringFromDate:[[_storybox playlistsQueue] startDate]];
    [dateFormatter release];
    self.storyboxPlaylistsQueueCount.text = [NSString stringWithFormat:@"%d",  [[[_storybox playlistsQueue] playlistGuids] count]];
    self.storyboxPlaylistsCollectedCount.text = @"0";
}

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator{
    [progressIndicator hide:YES afterDelay:1];
}

#pragma mark -
#pragma mark Collect Playlists Methods

-(IBAction)startCollectingPlaylists{
    [_storybox startCollectingPlaylistsUsingDelegate:self];
}

@end
