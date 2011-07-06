//
//  WeeklyBundle.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "WeeklyBundle.h"

@implementation WeeklyBundle

@synthesize guid=_guid;
@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize durationInMinutes=_durationInMinutes;
@synthesize playlists=_playlists;


-(WeeklyBundle *)initFromDictionary:(NSDictionary *)dictionary{
    return [self initWithGuid:[dictionary objectForKey:@"id"] startDate: [dictionary objectForKey:@"start_date"] endDate:[dictionary objectForKey:@"end_date"] durationInMinutes:[dictionary objectForKey:@"duration"] playlists:(NSArray *)[dictionary objectForKey:@"playlists"]];
}

-(WeeklyBundle *)initWithGuid:(NSString *)guid startDate:(NSString *)startDate endDate:(NSString *)endDate durationInMinutes:(NSNumber *)durationInMinutes playlists:(NSArray *)playlists{
    self = [super init];
    if(self){
        self.guid = guid;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        self.startDate = [dateFormatter dateFromString:startDate];
        self.endDate = [dateFormatter dateFromString:endDate];
        
        [dateFormatter release];
        
        self.durationInMinutes = [durationInMinutes unsignedIntegerValue];
        
        NSMutableArray *newPlaylists = [[NSMutableArray alloc] 
                                        initWithCapacity:[playlists count]];
        [playlists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *content = (NSDictionary *)obj;
            
            NSString *storyJockey = [(NSDictionary *)[content objectForKey:@"curator"] objectForKey:@"firstname"];
            
            Playlist *playlist = [[Playlist alloc] initWithGuid:[content objectForKey:@"id"] title:[content objectForKey:@"title"] storyJockey:storyJockey summary:[content objectForKey:@"full_summary"] duration:[content objectForKey:@"duration"] programmes:(NSArray *)[content objectForKey:@"programmes"]];
            
            [newPlaylists addObject:playlist];
            [playlist release];
        }];       
        
        self.playlists = newPlaylists;
        [newPlaylists release];
    }
    return self;
}

-(NSDecimalNumber *)durationInHours{
    NSDecimalNumber *result = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", self.durationInMinutes]];
   return [result decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"60.00"]];
}

- (void)dealloc {
    [self.guid release];
    [self.startDate release];
    [self.endDate release];
    [self.playlists release];
    [super dealloc];
}
@end
