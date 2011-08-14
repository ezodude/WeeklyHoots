//
//  StoryboxViewController.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "StoryboxViewController.h"
#import "StoryboxLoader.h"
#import "PlaylistsQueue.h"
#import "Storybox.h"
#import "Playlist.h"

@implementation StoryboxViewController

@synthesize navController=_navController;

@synthesize storyboxImageView=_storyboxImageView;
@synthesize startDateDayLabel=_startDateDayLabel;
@synthesize startDateMonthYearLabel=_startDateMonthYearLabel;
@synthesize storyboxPlaylistsQueueCount=_storyboxPlaylistsQueueCount;
@synthesize storyboxPlaylistsCollectedCount=_storyboxPlaylistsCollectedCount;
@synthesize collectPlaylistsButton=_collectPlaylistsButton;

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
    [self.storyboxImageView release];
    [self.startDateDayLabel release];
    [self.startDateMonthYearLabel release];
    [self.storyboxPlaylistsQueueCount release];
    [self.storyboxPlaylistsCollectedCount release];
    
    [self.collectPlaylistsButton release];
    
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
    static int BackgroundImageTargetHeight = 132;
    
    NSLog(@"Setting up image: [%@]", [[_storybox playlistsQueue] imageUri]);
    
    UIImage *image = [UIImage imageNamed:[[_storybox playlistsQueue] imageUri]];
    
    image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(ContentViewWidth, BackgroundImageTargetHeight ) interpolationQuality:kCGInterpolationHigh];
    
    image = [image croppedImage:CGRectMake(0, 0, ContentViewWidth, BackgroundImageTargetHeight)];
    
    [self.storyboxImageView setImage:image];
    [self.storyboxImageView.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
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
        
        [self.collectPlaylistsButton setTitle:@"Collect" forState:UIControlStateNormal];
        [_storybox stopCollectingPlaylists];
    }
    else{
        NSLog(@"**Collect**");
        
        [self.collectPlaylistsButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_storybox collectPlaylistsUsingDelegate:self];
    }
}

-(void)addPlaylistUndergoingDownload:(Playlist *)playlist{
    NSLog(@"Add playlist undergoing download");
    
    NSMutableArray *newCurrentPlaylists = [NSMutableArray arrayWithArray:self.storyboxCurrentPlaylists];
    
    playlist.title = [NSString stringWithFormat:@"* %@", playlist.title];
    [newCurrentPlaylists insertObject:playlist atIndex:0];
    
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:newCurrentPlaylists];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.allPlaylistsTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)playlistCompletedDownloading:(Playlist *)playlist{
    NSLog(@"Add playlist completed downloading");
    
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:[_storybox currentPlaylistsSlot]];
    
    playlist.title = [playlist.title substringFromIndex:2];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.allPlaylistsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self loadStoryboxCollectionLabels];
}

-(void)finishedCollectingPlaylists{
    NSLog(@"Finished Collecting Playlists");
    [self.collectPlaylistsButton setTitle:@"Collected" forState:UIControlStateNormal];
    self.collectPlaylistsButton.enabled = NO;
}

-(void)stopCollectingPlaylists{
    self.storyboxCurrentPlaylists = [NSArray arrayWithArray:[_storybox currentPlaylistsSlot]];
    [self.allPlaylistsTableView reloadData];

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    Playlist *playlist = section == 0 ? [self.storyboxCurrentPlaylists objectAtIndex:row] : [self.storyboxOlderPlaylists objectAtIndex:row];
    
    cell.textLabel.text = playlist.title;
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate Methods

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    Playlist *playlist = section == 0 ? [self.storyboxCurrentPlaylists objectAtIndex:row] : [self.storyboxOlderPlaylists objectAtIndex:row];
    
    
    return ([[playlist.title substringToIndex:2] isEqualToString:@"* "]) ? nil : indexPath;
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
@end
