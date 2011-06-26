//
//  WeeklyBundle.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "WeeklyBundle.h"

@implementation WeeklyBundle

@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize durationInHours=_durationInHours;
@synthesize playlists=_playlists;


-(WeeklyBundle *)initFromDictionary:(NSDictionary *)dictionary{
//    NSLog(@"Bundle: %@", [dictionary description]);
    NSLog(@"Bundle start: %@", [dictionary objectForKey:@"start_date"]);
    NSLog(@"Bundle end: %@", [dictionary objectForKey:@"end_date"]);
    NSLog(@"Bundle duration: %@", [dictionary objectForKey:@"duration_in_hours"]);
    
    return [self initWithStartDate: [dictionary objectForKey:@"start_date"] endDate:[dictionary objectForKey:@"end_date"] durationInHours:[dictionary objectForKey:@"duration_in_hours"] playlists:(NSArray *)[dictionary objectForKey:@"playlists"]];
}

-(WeeklyBundle *)initWithStartDate:(NSString *)startDate endDate:(NSString *)endDate durationInHours:(NSString *)durationInHours playlists:(NSArray *)playlists{
    self = [super init];
    if(self){
        self.startDate = startDate;
        self.endDate = endDate;
        self.durationInHours = durationInHours;
        
        NSMutableArray *newPlaylists = [[NSMutableArray alloc] 
                                        initWithCapacity:[playlists count]];
        [playlists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *content = (NSDictionary *)obj;
            
            NSString *storyJockey = [(NSDictionary *)[content objectForKey:@"curator"] objectForKey:@"firstname"];
            
            Playlist *playlist = [[Playlist alloc] initWithTitle:[content objectForKey:@"title"]
                                            storyJockey:storyJockey
                                            summary:[content objectForKey:@"full_summary"]
                                            duration:[content objectForKey:@"duration"]
                                            programmes:(NSArray *)[content objectForKey:@"programmes"]];
            [newPlaylists addObject:playlist];
            [playlist release];
        }];       
        
        self.playlists = newPlaylists;
        [newPlaylists release];
    }
    return self;
}

- (void)dealloc {
    [self.startDate release];
    [self.endDate release];
    [self.durationInHours release];
    [self.playlists release];
    [super dealloc];
}
@end
