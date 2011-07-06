//
//  Playlist.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

@synthesize guid=_guid;
@synthesize title=_title;
@synthesize storyJockey=_storyJockey ;
@synthesize summary=_summary;
@synthesize duration=_duration;
@synthesize publicationDate=_publicationDate;
@synthesize programmes=_programmes;

-(Playlist *)initWithGuid:(NSString *)guid title:(NSString *)title storyJockey:(NSString *)storyJockey summary:(NSString *)summary duration:(NSNumber *)duration programmes:(NSArray *)programmes{
    self = [super init];
    if(self){
        self.title = title;
        self.storyJockey = storyJockey;
        self.summary = summary;
        self.duration = [duration unsignedIntegerValue];
        
        NSMutableArray *newProgrammes = [[NSMutableArray alloc] 
                                         initWithCapacity:[programmes count]];
        [programmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *content = (NSDictionary *)obj;
            
            Programme *prog = [[Programme alloc] initWithGuid:[content objectForKey:@"id"] title:[content objectForKey:@"title"] duration:[content objectForKey:@"duration"] audioURI:[content objectForKey:@"audio_uri"]];
            
            [newProgrammes addObject:prog];
            [prog release];
        }];
        self.programmes = newProgrammes;
        [newProgrammes release];
    }
    return self;
}

- (void)dealloc {
    [self.guid release];
    [self.title release];
    [self.storyJockey release];
    [self.summary release];
    [self.publicationDate release];
    [self.programmes release];
    [super dealloc];
}
@end
