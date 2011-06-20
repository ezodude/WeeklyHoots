//
//  Playlist.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Playlist.h"


@implementation Playlist

@synthesize title=_title;
@synthesize storyJockey=_storyJockey ;
@synthesize summary=_summary;
@synthesize duration=_duration;
@synthesize publicationDate=_publicationDate;
@synthesize programmes=_programmes;

-(Playlist *)initWithTitle:(NSString *)title 
                storyJockey:(NSString *)storyJockey 
                summary:(NSString *)summary duration:(NSString *)duration
                programmes:(NSArray *)programmes{
    self = [super init];
    if(self){
        self.title = title;
        self.storyJockey = storyJockey;
        self.summary = summary;
        self.duration = duration;
        self.programmes = programmes;
    }
    return self;
}
@end
