//
//  StoryboxViewController.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "StoryboxViewController.h"
#import "PlaylistDetailsViewController.h"
#import "StoryboxLoader.h"
#import "PlaylistsQueue.h"
#import "Storybox.h"
#import "Playlist.h"
#import "StoryboxCell.h"

@implementation StoryboxViewController

@synthesize navController=_navController;

@synthesize storyboxImageView=_storyboxImageView;
@synthesize startDateDayLabel=_startDateDayLabel;
@synthesize startDateMonthYearLabel=_startDateMonthYearLabel;
@synthesize storyboxPlaylistsQueueCount=_storyboxPlaylistsQueueCount;
@synthesize storyboxPlaylistsCollectedCount=_storyboxPlaylistsCollectedCount;
@synthesize collectPlaylistsButton=_collectPlaylistsButton;
@synthesize collectPlaylistsButtonCaption=_collectPlaylistsButtonCaption;

@synthesize introBackgroundImage=_introBackgroundImage;
@synthesize allPlaylistsTableView=_allPlaylistsTableView;

@synthesize storyboxCurrentPlaylists=_storyboxCurrentPlaylists;
@synthesize storyboxOlderPlaylists=_storyboxOlderPlaylists;

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
    [self.navController release];
    [_detailsController release];
    
    [self.storyboxImageView release];
    [self.startDateDayLabel release];
    [self.startDateMonthYearLabel release];
    [self.storyboxPlaylistsQueueCount release];
    [self.storyboxPlaylistsCollectedCount release];
    
    [self.collectPlaylistsButton release];
    [self.collectPlaylistsButtonCaption release];
    
    [self.introBackgroundImage release];
    [self.allPlaylistsTableView release];
    
    [_storybox release];
    [self.storyboxCurrentPlaylists release];
    [self.storyboxOlderPlaylists release];
    
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
    self.allPlaylistsTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
    
    [self loadLatestStoryboxContent];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [_detailsController release];
    _detailsController = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(loadLatestStoryboxContent) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Refresh Storybox Content Methods

-(void)loadLatestStoryboxContent{
    if (_storybox && [_storybox collectionMode]) return;
    
    self.navController = [[[UIApplication sharedApplication] delegate] storyboxNavController];
    
    MBProgressHUD *HUD = [[MBProgressHUD showHUDAddedTo:self.navController.view animated:YES] retain];
    StoryboxLoader *loader = [StoryboxLoader loader];
    
    [loader setupStoryboxUsingProgressIndicator:HUD 
        WithCallback:^{
            _storybox = [[loader storybox] retain];
            [self loadStoryboxImage];
            [self configureCollectionButton];
            [self loadStoryboxDateLabel];
            [self loadStoryboxCollectionLabels];
            [self loadStoryboxPlaylists];
            [self cleanUpProgressIndicator:HUD];
        }
     ];
}

-(void)loadStoryboxImage{
    static int ContentViewWidth = 320;
    static int BackgroundImageTargetHeight = 150;
    
    NSLog(@"Setting up image: [%@]", [[_storybox playlistsQueue] imageUri]);
    
    UIImage *image = [UIImage imageNamed:[[_storybox playlistsQueue] imageUri]];
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(ContentViewWidth, BackgroundImageTargetHeight ) interpolationQuality:kCGInterpolationHigh];
    
//    image = [image croppedImage:CGRectMake(0, 0, ContentViewWidth, BackgroundImageTargetHeight)];
    
    [self.storyboxImageView setImage:image];
    [self.storyboxImageView setContentMode:UIViewContentModeCenter];
}

-(void)configureCollectionButton{
    if(![_storybox allPlaylistsCollected]) return;
    [self finishedCollectingPlaylists];
}

-(void)loadStoryboxDateLabel{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"dd" options:0 locale:[NSLocale currentLocale]]];
    
    self.startDateDayLabel.text = [dateFormatter 
                                stringFromDate:[[_storybox playlistsQueue] startDate]];
    
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MMMYY" options:0 locale:[NSLocale currentLocale]]];
    self.startDateMonthYearLabel.text = [dateFormatter 
                                stringFromDate:[[_storybox playlistsQueue] startDate]];
    [dateFormatter release];
}

-(void)loadStoryboxCollectionLabels{
    self.storyboxPlaylistsQueueCount.text = [NSString stringWithFormat:@"%d",  [[[_storybox playlistsQueue] playlistGuids] count]];
    self.storyboxPlaylistsCollectedCount.text = [NSString stringWithFormat:@"%d",  [[_storybox currentPlaylistsSlot] count]];
}

-(void)loadStoryboxPlaylists{
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:[_storybox currentPlaylistsSlot]];
    self.storyboxOlderPlaylists = [NSArray arrayWithArray:[_storybox olderPlaylistsSlot]];
    
    if ([self.storyboxCurrentPlaylists count] > 0 || [self.storyboxOlderPlaylists count] > 0) {
        [self.introBackgroundImage setHidden:YES];
        [self.allPlaylistsTableView setHidden:NO];
    }else{
        [self.introBackgroundImage setHidden:NO];
        [self.allPlaylistsTableView setHidden:YES];
    }
    
    [self.allPlaylistsTableView reloadData];
}

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator{
    [progressIndicator hide:YES afterDelay:1];
}

#pragma mark -
#pragma mark Collect Playlists Methods

-(IBAction)collectPlaylists:(id)sender{
    NSLog(@"startCollectingPlaylists");
    
    BOOL previouslyInCollectionMode = [_storybox collectionMode];
    
    if (previouslyInCollectionMode){
        NSLog(@"**Stop**");
        [_storybox stopCollectingPlaylists];
    }
    else{
        NSLog(@"**Collect**");
        [self drawStartCollectionState];
        [_storybox collectPlaylistsUsingDelegate:self];
    }
}

-(void)drawStopCollectionState{
    [self.collectPlaylistsButton setImage:[UIImage imageNamed:@"collect-normal"] forState:UIControlStateNormal];
    
    [self.collectPlaylistsButton setImage:[UIImage imageNamed:@"collect-highlighted"] forState:UIControlStateHighlighted];
    
    self.collectPlaylistsButtonCaption.text = @"download";
}

-(void)drawStartCollectionState{
    [self.collectPlaylistsButton setImage:[UIImage imageNamed:@"stop-normal"] forState:UIControlStateNormal];
    
    [self.collectPlaylistsButton setImage:[UIImage imageNamed:@"stop-highlighted"] forState:UIControlStateHighlighted];
    
    self.collectPlaylistsButtonCaption.text = @"stop";
}

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist{
    NSLog(@"Add playlist undergoing download");
    
    [self.introBackgroundImage setHidden:YES];
    [self.allPlaylistsTableView setHidden:NO];
    
    NSMutableArray *newCurrentPlaylists = [NSMutableArray arrayWithArray:self.storyboxCurrentPlaylists];
    
    [newCurrentPlaylists insertObject:playlist atIndex:0];
    
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:newCurrentPlaylists];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.allPlaylistsTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)setProgress:(float)amount{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    StoryboxCell *cell = (StoryboxCell *)[self.allPlaylistsTableView cellForRowAtIndexPath:path];
    NSLog(@"Amount: [%f]", amount);
    [cell.progressView setProgress:amount];
}

-(void)playlistCompletedDownloading:(Playlist *)playlist{
    NSLog(@"Add playlist completed downloading");
    
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:[_storybox currentPlaylistsSlot]];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.allPlaylistsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self loadStoryboxCollectionLabels];
}

-(void)playlistHasFailed:(Playlist *)playlist errorMsg:(NSString *)msg abortCollection:(BOOL)shouldAbort{
    
    if (!shouldAbort && playlist) {
        self.storyboxCurrentPlaylists = [NSArray arrayWithArray:[_storybox currentPlaylistsSlot]];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.allPlaylistsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];    
    }
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Download Cancelled" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    [alert show];
}

-(void)finishedCollectingPlaylists{
    NSLog(@"Finished Collecting Playlists");
    
    self.collectPlaylistsButton.enabled = NO;
    
    [self.collectPlaylistsButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateDisabled];

    self.collectPlaylistsButtonCaption.text = @"done!";
}

-(void)stopCollectingPlaylists{
    NSLog(@"stopCollectingPlaylists in StoryboxViewController");
    
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:[_storybox currentPlaylistsSlot]];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.allPlaylistsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
    
//    [self.allPlaylistsTableView reloadData];
    [self resetCollectionState];
}

-(void)resetCollectionState{
    if ([self.storyboxCurrentPlaylists count] == 0) {
        [self.allPlaylistsTableView setHidden:YES];
        [self.introBackgroundImage setHidden:NO];
    }
    
    [self drawStopCollectionState];
    [self loadStoryboxCollectionLabels];
}

#pragma mark -
#pragma mark TableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"self.storyboxOlderPlaylists count: [%d]", [self.storyboxOlderPlaylists count]);
    if([self.storyboxOlderPlaylists count] > 0) return 2;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? [self.storyboxCurrentPlaylists count] : [self.storyboxOlderPlaylists count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0 ? nil : @"Previous Storybox Collection...";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    StoryboxCell *cell = (StoryboxCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StoryboxCell"
                                                     owner:self options:nil];
        for (id oneObject in nib) 
            if ([oneObject isKindOfClass:[StoryboxCell class]])
                cell = (StoryboxCell *)oneObject;
    }

    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    Playlist *playlist = section == 0 ? [self.storyboxCurrentPlaylists objectAtIndex:row] : [self.storyboxOlderPlaylists objectAtIndex:row];

    [cell setupPlaylist:playlist];
    [cell configureReadiness];
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate Methods

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    Playlist *playlist = section == 0 ? [self.storyboxCurrentPlaylists objectAtIndex:row] : [self.storyboxOlderPlaylists objectAtIndex:row];
    
    return [playlist hasCompleteDownloads] ? indexPath : nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    Playlist *playlist = section == 0 ? [self.storyboxCurrentPlaylists objectAtIndex:row] : [self.storyboxOlderPlaylists objectAtIndex:row];
    
    NSArray *programmeDownloadFilepaths = [playlist downloadFilepathsForProgrammes];
    
    __block NSMutableArray *playable = [NSMutableArray arrayWithCapacity:[programmeDownloadFilepaths count]];
    [programmeDownloadFilepaths enumerateObjectsUsingBlock:^(id filepath, NSUInteger idx, BOOL *stop) {
        NSLog(@"Filepath: [%@]", filepath);
        
        MDAudioFile *audioFile = [[[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:filepath]] autorelease];
        [playable addObject:audioFile];
    }];
    
	MDAudioPlayerController *audioPlayer = [[MDAudioPlayerController alloc] initWithSoundFiles:playable atPath:[playlist audioDownloadsPath] andSelectedIndex:0];
    
	[self.navController presentModalViewController:audioPlayer animated:YES];
    
	[audioPlayer release];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (_detailsController == nil) {
        _detailsController = [[PlaylistDetailsViewController alloc] initWithNibName:@"PlaylistDetailsView" bundle:nil];
    }
    
    [_detailsController setTitle:@"Playlist Details"];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    Playlist *playlist = section == 0 ? [self.storyboxCurrentPlaylists objectAtIndex:row] : [self.storyboxOlderPlaylists objectAtIndex:row];
    
    [_detailsController setSourcePlaylist:playlist];
    [self.navController pushViewController:_detailsController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61.0;
}

@end
