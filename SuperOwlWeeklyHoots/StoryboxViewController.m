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
    StoryboxNavController *navController = [[[UIApplication sharedApplication] delegate] storyboxNavController];
    
    MBProgressHUD *HUD = [[MBProgressHUD showHUDAddedTo:navController.view animated:YES] retain];
    StoryboxManager *manager = [StoryboxManager manager];
    
    [manager setupPlaylistsQueueUsingProgressIndicator:HUD 
        WithCallback:^{
            [self cleanUpProgressIndicator:HUD];
        }
    ];
    [super viewDidLoad];
}

-(void)cleanUpProgressIndicator:(MBProgressHUD *)progressIndicator{
    progressIndicator.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    progressIndicator.mode = MBProgressHUDModeCustomView;
    [progressIndicator hide:YES afterDelay:2];
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

@end
