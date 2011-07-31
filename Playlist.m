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
@synthesize dateQueued=_dateQueued;
@synthesize expiryDate=_expiryDate;

-(Playlist *)initFromDictionary:(NSDictionary *)dictionary{
    return [self initWithGuid:[dictionary objectForKey:@"id"] title:[dictionary objectForKey:@"title"] storyJockey:[dictionary objectForKey:@"storyJockey"] summary:[dictionary objectForKey:@"summary"] duration:[dictionary objectForKey:@"duration"] dateQueued:[dictionary objectForKey:@"dateQueued"]
                   programmes:(NSArray *)[dictionary objectForKey:@"programmes"]];
}

-(Playlist *)initWithGuid:(NSString *)guid 
                    title:(NSString *)title 
              storyJockey:(NSString *)storyJockey 
                  summary:(NSString *)summary 
                 duration:(NSNumber *)duration 
               dateQueued:(NSString *) dateQueued
               programmes:(NSArray *)programmes{
    self = [super init];
    if(self){
        self.guid = guid;
        self.title = title;
        self.storyJockey = storyJockey;
        self.summary = summary;
        self.duration = [duration unsignedIntegerValue];
//        NSLog(@"Duration: [%d]", self.duration);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        self.dateQueued = [dateFormatter dateFromString:dateQueued];
        [dateFormatter release];
        
        self.expiryDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * REFRESH_FREQUENCY) sinceDate:self.dateQueued];
//        NSLog(@"Expires on [%@]", [self.expiryDate description]);
        
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

-(NSUInteger)totalProgrammesCount{
    if(!self.programmes) return 0;
    return [self.programmes count];
}

-(NSUInteger)downloadedProgrammesCount{
    if(!self.programmes) return 0;
    __block NSUInteger result;
    
    [self.programmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([obj downloaded])
            result++;
    }];
    
    return result;
}

-(NSArray *)programmesAwaitingDownload{
    NSPredicate *notDownloadedPredicate = 
    [NSPredicate predicateWithFormat:@"downloaded == NO"];
    
    return [self.programmes filteredArrayUsingPredicate:notDownloadedPredicate];
}

-(NSData *)JSONData{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *dateQueuedAsString = [dateFormatter stringFromDate:self.dateQueued];
    NSString *expiryDateAsString = [dateFormatter stringFromDate:self.expiryDate];
    
    __block NSMutableArray *playlistProgrammesAsDictionaries = [NSMutableArray arrayWithCapacity:[self.programmes count]];
    [self.programmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Programme *prog = (Programme *)obj;
        [playlistProgrammesAsDictionaries addObject:[prog dictionaryFromObject]];
    }];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.guid, @"id", self.title, @"title", self.storyJockey, @"storyJockey", self.summary, @"summary", [NSNumber numberWithUnsignedInt: self.duration], @"duration", dateQueuedAsString, @"dateQueued", expiryDateAsString, @"expiryDate", playlistProgrammesAsDictionaries, @"programmes", nil];
    
    [dateFormatter release];
    
    NSLog(@"JSON: [%@]", [dictionary JSONString]);
    
    return [dictionary JSONData];
}

- (void)dealloc {
    [self.guid release];
    [self.title release];
    [self.storyJockey release];
    [self.summary release];
    [self.publicationDate release];
    [self.programmes release];
    [self.dateQueued release];
    [self.expiryDate release];
    [super dealloc];
}
@end
