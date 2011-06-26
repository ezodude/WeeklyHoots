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
                summary:(NSString *)summary duration:(NSNumber *)duration
                programmes:(NSArray *)programmes{
    self = [super init];
    if(self){
        self.title = title;
        self.storyJockey = storyJockey;
        self.summary = summary;
        self.duration = duration;
        
        NSMutableArray *newProgrammes = [[NSMutableArray alloc] 
                                         initWithCapacity:[programmes count]];
        [programmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *content = (NSDictionary *)obj;
            Programme *prog = [[Programme alloc] initWithTitle:[content objectForKey:@"title"] duration:[content objectForKey:@"duration"]];
            [newProgrammes addObject:prog];
            
            [prog release];
        }];
        self.programmes = programmes;
        [newProgrammes release];
    }
    return self;
}

- (void)dealloc {
    [self.title release];
    [self.storyJockey release];
    [self.summary release];
    [self.duration release];
    [self.publicationDate release];
    [self.programmes release];
    [super dealloc];
}
@end
