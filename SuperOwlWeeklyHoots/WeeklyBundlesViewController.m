//
//  WeeklyBundlesViewController.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 04/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "WeeklyBundlesViewController.h"
#import "SuperOwlWeeklyHootsAppDelegate.h"

@implementation WeeklyBundlesViewController

@synthesize currentBundle=_currentBundle;
@synthesize recentBundle=_recentBundle;

@synthesize currentOrRecentBundleControl=_currentOrRecentBundleControl;

@synthesize startWeekDayNameLabel=_startWeekDayNameLabel;
@synthesize endWeekDayNameLabel=_endWeekDayNameLabel;
@synthesize startDayDateLabel=_startDayDateLabel;
@synthesize endDayDateLabel=_endDayDateLabel;

@synthesize bundleDurationLabel=_bundleDurationLabel;
@synthesize syncedDurationLabel=_syncedDurationLabel;
@synthesize bundleSyncStatusBar=_bundleSyncStatusBar;

@synthesize playlistsMenu=_playlistsMenu;

@synthesize syncButton=_syncButton;
@synthesize listenButton=_listenButton;

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
    [self.currentBundle release];
    [self.recentBundle release];
    [self.currentOrRecentBundleControl release];
    
    [self.startWeekDayNameLabel release];
    [self.endWeekDayNameLabel release];
    [self.startDayDateLabel release];
    [self.endDayDateLabel release];
    
    [self.bundleDurationLabel release];
    [self.syncedDurationLabel release];
    [self.bundleSyncStatusBar release];
    
    [self.playlistsMenu release];
    
    [self.syncButton release];
    [self.listenButton release];
    
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
    WeeklyBundlesNavController *navController = [[[UIApplication sharedApplication] delegate] weeklyBundlesNavController];
    
    MBProgressHUD *HUD = [[MBProgressHUD showHUDAddedTo:navController.view animated:YES] retain];
    [self loadDataUsingProgressIndicator:HUD];
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
#pragma mark Weekly Bundle Drawing Methods

-(IBAction)toggleControls:(id)sender{
    NSLog(@"Toggel Happened!");
}

-(void)loadDataUsingProgressIndicator:(MBProgressHUD *)progressIndicator{
    BundlesManager *bundlesManager = [BundlesManager manager];
    
    [bundlesManager setupBundlesUsingProgressIndicator:progressIndicator WithCallback:^{
        [self setCurrentBundle:[bundlesManager currentBundle]];
        [self setRecentBundle:[bundlesManager recentBundle]];
        [self cleanUpProgressIndicator:progressIndicator];
        [self drawViewUsingBundle:self.currentBundle];
    }];
}

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator{
    progressIndicator.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    [progressIndicator hide:YES afterDelay:2];
}

-(void)drawViewUsingBundle:(WeeklyBundle *)bundle{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];  
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"E" options:0 locale:[NSLocale currentLocale]]];
    self.startWeekDayNameLabel.text = [[dateFormatter stringFromDate:[bundle startDate]] uppercaseString];
    self.endWeekDayNameLabel.text = [[dateFormatter stringFromDate:[bundle endDate]] uppercaseString];
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"dMMMYY" options:0 locale:[NSLocale currentLocale]]];
    self.startDayDateLabel.text = [dateFormatter stringFromDate:[bundle startDate]];
    self.endDayDateLabel.text = [dateFormatter stringFromDate:[bundle endDate]];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfDown];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:0.5]];

    self.bundleDurationLabel.text = [NSString stringWithFormat:@"%@ hrs", [formatter stringFromNumber:[self.currentBundle durationInHours]]];

    [formatter release];
    [self drawButtons];
}

-(void)drawButtons{
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    
    [self.syncButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.syncButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
    [self.listenButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.listenButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *PlaylistsTableIdentifier = @"PlaylistsTableIdentifier";
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:PlaylistsTableIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaylistsTableIdentifier] autorelease];
    }
    
    cell.textLabel.text = @"Playlists";
    return cell;
}
@end
