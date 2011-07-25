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
@synthesize activeBundle=_activeBundle;

@synthesize bundlesTable;

@synthesize syncProgressStatus=_syncProgressStatus;

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
    [self.activeBundle release];
    
    [self.bundlesTable release];
    
    [_internetReachable release];
    [_audioDownloadsRunner release];
        
    [self.syncProgressStatus release];
    
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

-(void) viewWillAppear:(BOOL)animated
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    _internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [_internetReachable startNotifier];    
}

- (void)viewDidLoad
{
    bundlesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    bundlesTable.rowHeight = 184;
    bundlesTable.backgroundColor = [UIColor clearColor];
    
    WeeklyBundlesNavController *navController = [[[UIApplication sharedApplication] delegate] weeklyBundlesNavController];
    
    MBProgressHUD *HUD = [[MBProgressHUD showHUDAddedTo:navController.view animated:YES] retain];
    HUD.labelText = @"Loading bundles";
    
    [self loadDataUsingProgressIndicator:HUD];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Internet Reachability Methods

- (void) checkNetworkStatus:(NSNotification *)notice
{
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    _wifiConnected = (internetStatus == ReachableViaWiFi);
}

#pragma mark -
#pragma mark Weekly Bundle Drawing Methods

-(void)loadDataUsingProgressIndicator:(MBProgressHUD *)progressIndicator{
    BundlesManager *bundlesManager = [BundlesManager manager];
    
    [bundlesManager setupBundlesUsingProgressIndicator:progressIndicator WithCallback:^{
        [self setCurrentBundle:[bundlesManager currentBundle]];
        [self setRecentBundle:[bundlesManager recentBundle]];
        [self setActiveBundle: self.currentBundle];
        
        [self cleanUpProgressIndicator:progressIndicator];
        [bundlesTable setHidden:NO];
        [bundlesTable reloadData];
//        [self drawViewUsingBundle];
    }];
    
}

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator{
    progressIndicator.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    [progressIndicator hide:YES afterDelay:2];
}

#pragma mark -
#pragma mark Sync Operations Methods
-(IBAction)processSyncing:(id)sender{
    if(!_wifiConnected){
        [self flagLackOfWifiConnection];
        return;
    }
    
    NSString *buttonTitle = [[[sender titleLabel] text] lowercaseString];
    
    if ([buttonTitle isEqualToString:@"sync"]){
        [self startSyncing:(UIButton *)sender];
    }
    else if([buttonTitle isEqualToString:@"pause"]){
        [self pauseSyncing:(UIButton *)sender];
    }
    else if([buttonTitle isEqualToString:@"resume"]){
        [self resumeSyncing:(UIButton *)sender];
    }
}

-(void)startSyncing:(UIButton *)button{
    [button setTitle:@"Pause" forState:UIControlStateNormal];
    [button setTitle:@"Pause" forState:UIControlStateHighlighted];
    
    [self syncUsingProgressView:nil];
}

-(void)pauseSyncing:(UIButton *)button{
    [button setTitle:@"Resume" forState:UIControlStateNormal];
    [button setTitle:@"Resume" forState:UIControlStateHighlighted];
    
    if(!_audioDownloadsRunner) return;
    
    [_audioDownloadsRunner pauseSyncing:self.activeBundle];
    [self.syncProgressStatus hide:YES afterDelay:0];
}

-(void)resumeSyncing:(UIButton *)button{
    [button setTitle:@"Pause" forState:UIControlStateNormal];
    [button setTitle:@"Pause" forState:UIControlStateHighlighted];
    
    [self syncUsingProgressView:nil];
}

-(void)signalSyncCompleted{
    NSLog(@"Sync Completed!");
//    [self.syncButton setTitle:@"Synced" forState:UIControlStateNormal];
//    [self.syncButton setTitle:@"Synced" forState:UIControlStateHighlighted];
//    [self.syncButton setEnabled:NO];
}

-(void)flagLackOfWifiConnection{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"No Wifi Detected!" message:@"Please switch on wifi to enable syncing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

-(void)syncUsingProgressView:(MBProgressHUD *)progressView{
    NSLog(@"startSyncingUsingProgressView");
    
    if(!_audioDownloadsRunner){
        _audioDownloadsRunner = [AudioDownloadsRunner runner];
    }
    
    self.syncProgressStatus = [MBProgressHUD showHUDAddedTo:nil animated:YES];
    
    [self.syncProgressStatus setLabelText:@"Syncing"];
    [self.syncProgressStatus setDetailsLabelText:[NSString stringWithFormat:@"%d", [[self activeBundle] programmesAwaitingDownloadCount]]];
    
//    [_audioDownloadsRunner startDownloadingBundleAudio:self.activeBundle progressView:self.syncProgressStatus];
    
//    [_audioDownloadsRunner prepareDownloadContextForBundle:self.activeBundle progressView:self.syncProgressStatus withProgressCallback:^{
////        [self drawProgrammesSyncedProgress];
//    }];
//    
//    [_audioDownloadsRunner startDownloadsForBundle:self.activeBundle withCompletionCallback:^{
//        [self.syncProgressStatus hide:YES afterDelay:0];
//        [self signalSyncCompleted];
//    }];
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger sectionIndex = [indexPath section];
    WeeklyBundle *bundle = (sectionIndex == 0 ? self.currentBundle : self.recentBundle);
//    if(!bundle) return nil;
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    BundleCell *cell = (BundleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BundleCell"
                                                     owner:self options:nil];
        for (id oneObject in nib)
            if([oneObject isKindOfClass:[BundleCell class]])
                cell = (BundleCell *)oneObject;
    }
    
    NSString *imageName = (sectionIndex == 0 ? 
                           @"london_double_decker_240x160.jpg" : 
                           @"rush_hour_240x160.jpg");
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EdMMMYY" options:0 locale:[NSLocale currentLocale]]];
    
    NSString *startDate = [dateFormatter stringFromDate:[bundle startDate]];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfDown];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:0.5]];
    
    NSString *listeningHoursTotal = [NSString stringWithFormat:@"%@ Hrs Listening", [formatter stringFromNumber:[self.activeBundle durationInHours]]];
    [formatter release];
    
    NSString *audioStoriesSyncedCount = [NSString stringWithFormat:@"%d of %d Audio Stories", [bundle downloadedProgrammesCount], [bundle totalProgrammesCount]];
    
    [cell setupWithBackgroundImage:imageName startDate:startDate listeningHoursTotal:listeningHoursTotal audioStoriesSyncedCount:audioStoriesSyncedCount];
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}
@end
