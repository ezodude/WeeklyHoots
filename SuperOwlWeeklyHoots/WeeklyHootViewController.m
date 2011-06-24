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
#import "JSONKit/JSONKit.h"

@implementation WeeklyHootViewController

@synthesize currentBundle=_currentBundle;
@synthesize lastBundle=_lastBundle;

- (void)viewDidLoad
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *programmesAPIURL = myEnvironment.programmesAPIURL;
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@bundles/current.json", programmesAPIURL]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary *dictionary = (NSDictionary *)[response objectFromJSONString];

        NSLog(@"The Bundle start date is: %@", [dictionary objectForKey:@"start_date"]);
    }
    
    self.tableView.sectionHeaderHeight = 66.0;  
    Programme *firstProg = [[Programme alloc] initWithTitle:@"Programme1" duration:@"30"];
    
    NSArray *progs = [[NSArray alloc] initWithObjects:firstProg, nil];
    Playlist *firstPlaylist = [[Playlist alloc] initWithTitle:@"Playlist 1" 
                                        storyJockey:@"Jock 1" 
                                        summary:@"Cool Summary" 
                                        duration:@"1" 
                                        programmes: progs];
    NSArray *playlists = [[NSArray alloc] initWithObjects:firstPlaylist, nil];
    WeeklyBundle *bundle = [[WeeklyBundle alloc] initWithStartDate:@"13th" endDate:@"19th June 11" durationInHours:@"10" playlists:playlists];
    
    self.currentBundle = bundle;
    
    [firstProg release];
    [firstPlaylist release];
    [progs release];
    [playlists release];
    [bundle release];
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
    [super dealloc];
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
    
    Playlist *playlist = (Playlist *)[[self.currentBundle playlists] 
                                      objectAtIndex:[indexPath row]];
    cell.textLabel.text = [playlist title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"By %@", [playlist storyJockey]];
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
    
    header.startToEndDateLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.currentBundle startDate], [self.currentBundle endDate]];
    header.durationLabel.text = [NSString stringWithFormat:@"%@ Hrs", [self.currentBundle durationInHours]];
    return header;
}

@end