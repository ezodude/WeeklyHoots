//
//  FirstViewController.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 17/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Environment.h"
#import "WeeklyHootViewController.h"
#import "WeeklyBundle.h"
#import "Playlist.h"
#import "Programme.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit/JSONKit.h"

@implementation WeeklyHootViewController

@synthesize currentBundle=_currentBundle;
@synthesize lastBundle=_lastBundle;
@synthesize networkQueue=_networkQueue;
@synthesize audioAvailable=_audioAvailable;
@synthesize player=_player;

- (void)viewDidLoad
{
    self.audioAvailable = NO;
    self.tableView.sectionHeaderHeight = 66.0;
    
//    Environment *myEnvironment = [Environment sharedInstance];
//    NSString *programmesAPIURL = myEnvironment.programmesAPIURL;
//    NSString *urlPath = [NSString stringWithFormat:@"%@bundles/current.json", programmesAPIURL];
    
    BundlesManager *bundlesManager = [BundlesManager manager];
    [bundlesManager setupBundlesWithCallback:^{
        [self setCurrentBundle:[bundlesManager currentBundle]];
        [self.tableView reloadData];
    }];
//    [self grabURLInBackground:urlPath];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


/*- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}*/


- (void)dealloc
{
    [self.currentBundle release];
    [self.lastBundle release];
    [self.networkQueue release];
    [self.player release];
    [super dealloc];
}

#pragma mark -
#pragma mark Bundle Ingestor Methods

- (void)grabURLInBackground:(NSString *)urlPath
{
    NSURL *url = [NSURL URLWithString:urlPath];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSDictionary *dictionary = (NSDictionary *)[responseString objectFromJSONString];
    
    WeeklyBundle *bundle = [[WeeklyBundle alloc] initFromDictionary:dictionary];
    self.currentBundle = bundle;
    [self.tableView reloadData];
    [bundle release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark TableView Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.currentBundle playlists] count];
}
     
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"Previously...";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *PlaylistId = @"PlaylistId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaylistId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaylistId] autorelease];
    }
    
    if(self.currentBundle){
        Playlist *playlist = (Playlist *)[[self.currentBundle playlists] 
                                          objectAtIndex:[indexPath row]];
        cell.textLabel.text = [playlist title];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", [playlist storyJockey]];
    }
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate Methods

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WeeklyHootSectionHeader *header = nil;
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"WeeklyHootSectionHeaderView" owner:self options:nil];
    
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:[UIView class]]) {
            header = (WeeklyHootSectionHeader *) currentObject;
            break;
        }
    }
    
    header.parentController = self;
    
    if(self.currentBundle){
        header.startToEndDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.currentBundle startDate], [self.currentBundle endDate]];
        header.durationLabel.text = [NSString stringWithFormat:@"%@ Hrs", [self.currentBundle durationInHours]];
        
        if(self.audioAvailable){
            header.playButton.hidden = NO;
            header.syncButton.hidden = YES;
            NSLog(@"Showing Play Button!");
        }else{
            header.playButton.hidden = YES;
            header.syncButton.hidden = NO;
            NSLog(@"Hiding Play Button!");
        }
    }
    return header;
}

#pragma mark -
#pragma mark Audio Stash Storage Methods

-(void)startSyncing{
    NSLog(@"Iam Syncing");
    [self createAudioStashDirectoryIfUnavailable];
    [self downloadCurrentBundleIfUnavailableLocally];
}

-(void)startPlaying{
    NSLog(@"start Playing");
    
    NSString *documentsDirectory = [self applicationDocumentsDirectory];
    if(!documentsDirectory) return;
    
    Programme *toPlay = [[[[self.currentBundle playlists] objectAtIndex:0] programmes] objectAtIndex:0];
    
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    
    NSString *audioStashDirectory = [documentsDirectory stringByAppendingFormat:AUDIO_STASH_DIR];
    
    NSString *extension = [[toPlay audioUri] pathExtension];
    NSString *fileToPlay = [audioStashDirectory stringByAppendingFormat:@"/%@", [[toPlay guid] stringByAppendingFormat:@".%@", extension]];
    
    if(![manager fileExistsAtPath:fileToPlay]) return;
    
    NSLog(@"About to Play: [%@]", fileToPlay);
    
    NSURL *fileToPlayAsURL = [NSURL fileURLWithPath:fileToPlay];
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileToPlayAsURL
                                                                      error: nil];
    self.player = newPlayer;
    [newPlayer release];
    
    [self.player setVolume: 1.0]; 
    [self.player prepareToPlay];
    [self.player setDelegate:self];
    
    if (self.player.playing)
        [self.player pause];
    else
        [self.player play];
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) completed {
    if (completed) {
        NSLog(@"Play completed");
//        [self.button setTitle: @"Play" forState: UIControlStateNormal];
    }
}

- (NSString *)applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
}

-(void)createAudioStashDirectoryIfUnavailable{
    NSLog(@"creating Audio Stash Directory If Unavailable");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    if ([paths count] > 0) {
        NSString *basePath = [paths objectAtIndex:0];
        NSString *audioStashDirectory = [basePath stringByAppendingFormat:AUDIO_STASH_DIR];
        
        NSFileManager *manager = [[NSFileManager alloc] init];
        [manager createDirectoryAtPath:audioStashDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        
        if([manager fileExistsAtPath:audioStashDirectory]){
            NSLog(@"File exists!!");
        }
        [manager release];
    }
}

- (void)queueRequestFinished:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
        
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		[self setNetworkQueue:nil]; 
	}
    
	//... Handle success
	NSLog(@"Request for [%@] Finished", [request originalURL]);
}

- (void)queueRequestFailed:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
    
	//... Handle failure
	NSLog(@"Request for [%@] FAILbED", [request originalURL]);
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
    [self markPlaylistAsDownloaded];
    
    NSLog(@"Completed downloads: [%@]", [[NSDate date] description]);
	NSLog(@"Queue finished");
}

-(void)downloadCurrentBundleIfUnavailableLocally{
    NSLog(@"downloading Current Bundle If UnavailableLocally");
    
    NSString *documentsDirectory = [self applicationDocumentsDirectory];
    if(!documentsDirectory) return;
    if(!self.currentBundle) return;
    
    [self.networkQueue cancelAllOperations];
    
    // Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
	[self setNetworkQueue:[ASINetworkQueue queue]];
	[[self networkQueue] setDelegate:self];
    [[self networkQueue] setMaxConcurrentOperationCount:3];
	[[self networkQueue] setRequestDidFinishSelector:@selector(queueRequestFinished:)];
	[[self networkQueue] setRequestDidFailSelector:@selector(queueRequestFailed:)];
	[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
        
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];    
    NSString *audioStashDirectory = [documentsDirectory stringByAppendingFormat:AUDIO_STASH_DIR];
    
    for (Playlist *playlist in [self.currentBundle playlists]) {
        for (Programme *prog in [playlist programmes]) {
            
            NSString *extension = [[[[prog.audioUri componentsSeparatedByString:@"?"] objectAtIndex:0] pathExtension] lowercaseString];
            NSString *fileToSave = [audioStashDirectory stringByAppendingFormat:@"/%@", [prog.guid stringByAppendingFormat:@".%@", extension]];
            
            if([manager fileExistsAtPath:fileToSave] == NO) {
                NSLog(@"Save This::: [%@]", fileToSave);
                
                NSURL *url = [NSURL URLWithString:prog.audioUri];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request setDownloadDestinationPath:fileToSave];
                
                [[self networkQueue] addOperation:request];
            }
        }
    }
    
    if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil];
        [self markPlaylistAsDownloaded];
	}else{
        [[self networkQueue] go];
    }
    NSLog(@"Starting downloads: [%@]", [[NSDate date] description]);    
}

-(void)markPlaylistAsDownloaded{
    NSLog(@"marking Playlist As Downloaded!");
    
    self.audioAvailable = YES;
    [self.tableView reloadData];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
    
    NSString *originalText = cell.textLabel.text;
    cell.textLabel.text = [@"**" stringByAppendingString:originalText];
}

@end