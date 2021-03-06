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
@synthesize programmes=_programmes;
@synthesize dateQueued=_dateQueued;
@synthesize expiryDate=_expiryDate;
@synthesize createdAt=_createdAt;

-(id)initFromDictionary:(NSDictionary *)dictionary{
    return [self initWithGuid:[dictionary objectForKey:@"id"] 
                        title:[dictionary objectForKey:@"title"] 
                  storyJockey:[dictionary objectForKey:@"storyJockey"] 
                      summary:[dictionary objectForKey:@"summary"] 
                     duration:[dictionary objectForKey:@"duration"] 
                   dateQueued:[dictionary objectForKey:@"dateQueued"]
                   expiryDate:[dictionary objectForKey:@"expiryDate"]
                 createdAt:[dictionary objectForKey:@"createdAt"]
                   programmes:[dictionary objectForKey:@"programmes"]];
}

-(id)initWithGuid:(NSString *)guid 
                    title:(NSString *)title 
              storyJockey:(NSString *)storyJockey 
                  summary:(NSString *)summary 
                 duration:(NSNumber *)duration 
               dateQueued:(NSString *)dateQueued
                expiryDate:(NSString *)expiryDate
                createdAt:(NSString *)createdAt
                programmes:(NSArray *)programmes{
    self = [super init];
    if(self){
        self.guid = guid;
        if(title) self.title = title;
        if(storyJockey) self.storyJockey = storyJockey;
        if(summary) self.summary = summary;
        if(duration) self.duration = [duration unsignedIntegerValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateQueued = [dateFormatter dateFromString:dateQueued];
        self.expiryDate = [dateFormatter dateFromString:expiryDate];
        
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        self.createdAt = [dateFormatter dateFromString:createdAt];
        
        [dateFormatter release];
        
//        self.expiryDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * REFRESH_FREQUENCY) sinceDate:self.dateQueued];
        
        if (programmes) {
            NSMutableArray *newProgrammes = [[NSMutableArray alloc] 
                                             initWithCapacity:[programmes count]];
            [programmes enumerateObjectsUsingBlock:^(id content, NSUInteger idx, BOOL *stop) {
                NSString *audioUri = [content objectForKey:@"audioURI"] == nil ? [content objectForKey:@"audio_uri"] : [content objectForKey:@"audioURI"];
                
                Programme *prog = [[Programme alloc] initWithGuid:[content objectForKey:@"id"] title:[content objectForKey:@"title"] duration:[content objectForKey:@"duration"] audioURI:audioUri];
                
                [newProgrammes addObject:prog];
                [prog release];
            }];
            self.programmes = newProgrammes;
            [newProgrammes release];
        }
    }
    return self;
}

-(NSString *)pathOnDisk{
    NSString *localPlaylistsPath = [Storybox allPlaylistsPath];
    return [NSString stringWithFormat:@"%@/%@", localPlaylistsPath, self.guid];
}

-(NSString *)audioDownloadsPath{
    return [NSString stringWithFormat:@"%@/programmes", [self pathOnDisk]];
}

-(NSArray *)downloadFilepathsForProgrammes{
    __block NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self.programmes count]];
    
    [self.programmes enumerateObjectsUsingBlock:^(id prog, NSUInteger idx, BOOL *stop) {
        NSString *filepath = [NSString stringWithFormat:@"%@/%@", [self audioDownloadsPath ], [prog  downloadFilename]];
        [result addObject:filepath];
    }];
    
    return result;
}

-(BOOL)isExpired{
    NSDate *today = [NSDate date];
    NSComparisonResult comparison = [self.expiryDate compare:today];
    
    return comparison == NSOrderedSame || comparison == NSOrderedAscending;
}

-(NSInteger)numberOfDaysBeforeExpiry{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *today = [NSDate date];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:today toDate:self.expiryDate options:0];

    [gregorianCalendar release];
    
    return [components day] + 1;
}

-(BOOL)hasCompleteDownloads{
    NSString *downloadsPath = [self audioDownloadsPath];
    
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    NSArray *downloadedFilenamesWithOSIndexes = [fileManager contentsOfDirectoryAtPath:downloadsPath error:nil];
    
    BOOL noProgrammesDownloadedYet = downloadedFilenamesWithOSIndexes == nil;
    if (noProgrammesDownloadedYet) return NO;
    
    NSPredicate *OSIndexPredicate = 
    [NSPredicate predicateWithFormat:@"SELF != %@", @".DS_Store"];
    NSArray *cleansedDownloadedFilenames = [downloadedFilenamesWithOSIndexes filteredArrayUsingPredicate:OSIndexPredicate];
    
    BOOL lessDownloadsThanPlaylistProgs = [self.programmes count] > [cleansedDownloadedFilenames count];
    if (lessDownloadsThanPlaylistProgs) return NO;
    
    for (NSString *filename in cleansedDownloadedFilenames){
        BOOL partialDownload = [[filename pathExtension] isEqualToString:@"download"];
        if (partialDownload) return NO;
    }
    return YES;
}

-(NSDictionary *)dictionaryFromObject{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateQueuedAsString = [dateFormatter stringFromDate:self.dateQueued];
    NSString *expiryDateAsString = [dateFormatter stringFromDate:self.expiryDate];
    
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSString *createdAtAsString = [dateFormatter stringFromDate:self.createdAt];
    
    [dateFormatter release];
    
    __block NSMutableArray *playlistProgrammesAsDictionaries = [NSMutableArray arrayWithCapacity:[self.programmes count]];
    
    [self.programmes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Programme *prog = (Programme *)obj;
        [playlistProgrammesAsDictionaries addObject:[prog dictionaryFromObject]];
    }];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [dictionary setObject:self.guid forKey:@"id"];
    [dictionary setObject:dateQueuedAsString forKey:@"dateQueued"];
    [dictionary setObject:expiryDateAsString forKey:@"expiryDate"];
    [dictionary setObject:createdAtAsString forKey:@"createdAt"];
    
    if (self.title) [dictionary setObject:self.title forKey:@"title"];
    if (self.storyJockey) [dictionary setObject:self.storyJockey forKey:@"storyJockey"];
    if (self.summary) [dictionary setObject:self.summary forKey:@"summary"];
    if (self.duration) [dictionary setObject:[NSNumber numberWithUnsignedInt: self.duration] forKey:@"duration"];
    if(self.programmes) [dictionary setObject:playlistProgrammesAsDictionaries forKey:@"programmes"];
    
    return dictionary;
}

-(NSData *)JSONData{
    return [[self dictionaryFromObject] JSONData];
}

-(BOOL)hasContent{
    return YES;
}

-(BOOL)isDisplayable{
    return [self hasContent];
}

-(BOOL)hasErrors{
    return NO;
}

- (void)dealloc {
    [self.guid release];
    [self.title release];
    [self.storyJockey release];
    [self.summary release];
    [self.programmes release];
    [self.dateQueued release];
    [self.expiryDate release];
    [self.createdAt release];
    [super dealloc];
}
@end
