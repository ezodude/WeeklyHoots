//
//  PlaylistDetailsViewController.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 22/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "PlaylistDetailsViewController.h"
#import "Playlist.h"
#import "Programme.h"

@implementation PlaylistDetailsViewController

@synthesize sourcePlaylist=_sourcePlaylist;

@synthesize playlistTitle=_playlistTitle;
@synthesize storyJockeyName=_storyJockeyName;    
@synthesize daysRemaining=_daysRemaining;
@synthesize summaryAndProgsTableView=_summaryAndProgsTableView;

@synthesize storyJockeyImageView=_storyJockeyImageView;

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
    [self.sourcePlaylist release];
    
    [self.playlistTitle release];
    [self.storyJockeyName release];
    [self.storyJockeyImageView release];
    [self.daysRemaining release];
    [self.summaryAndProgsTableView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
    self.storyJockeyImageView.image = [UIImage imageNamed:self.sourcePlaylist.storyJockey];
    self.playlistTitle.text = self.sourcePlaylist.title;
    self.storyJockeyName.text = self.sourcePlaylist.storyJockey;
    
    NSString *daysRemaining = self.sourcePlaylist.numberOfDaysBeforeExpiry == 0 ? @"Last day" : [NSString stringWithFormat:@"%d days left", self.sourcePlaylist.numberOfDaysBeforeExpiry];
    self.daysRemaining.text = daysRemaining;
    
    [self.summaryAndProgsTableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
//    self.summaryAndProgsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.summaryAndProgsTableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.sourcePlaylist = nil;
    
    self.playlistTitle = nil;
    self.storyJockeyName = nil;
    self.daysRemaining = nil;
    self.summaryAndProgsTableView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGFloat)RAD_textHeightForText:(NSString *)text systemFontOfSize:(CGFloat)size 
{
    //Calculate the expected size based on the font and linebreak mode of the label
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
    CGFloat maxHeight = 9999;
    CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
    
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap]; 
    
    return expectedLabelSize.height;
}

#pragma mark -
#pragma mark TableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : [[self.sourcePlaylist programmes] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    return [indexPath section] == 0 ? [self RAD_textHeightForText:[self.sourcePlaylist summary] systemFontOfSize:15] + 10.0 : 45.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if (section == 0) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = self.sourcePlaylist.summary;
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }else{
        Programme *prog = [[self.sourcePlaylist programmes]objectAtIndex:row];
        cell.textLabel.text = prog.title;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"headphones"];
    }
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate Methods

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
