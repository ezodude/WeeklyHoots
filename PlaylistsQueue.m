//
//  PlaylistsQueue.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "PlaylistsQueue.h"


@implementation PlaylistsQueue

@synthesize guid=_guid;
@synthesize startDate=_startDate;
@synthesize endDate=_endDate;
@synthesize playlistsValidity=_playlistsValidity;
@synthesize imageUri=_imageUri;
@synthesize playlistGuids=_playlistGuids;

- (id)initFromDictionary:(NSDictionary *)dictionary{
    return [self initWithGuid:[dictionary objectForKey:@"id"] startDate: [dictionary objectForKey:@"start_date"] endDate: [dictionary objectForKey:@"end_date"] playlistsValidity:[dictionary objectForKey:@"playlists_validity"] imageUri:[dictionary objectForKey:@"image_uri"] playlistGuids:(NSArray *)[dictionary objectForKey:@"playlist_guids"]];
}

- (PlaylistsQueue *)initWithGuid:(NSString *)guid startDate:(NSString *)startDate endDate:(NSString *)endDate playlistsValidity:(NSNumber *)playlistsValidity imageUri:(NSString *)imageUri playlistGuids:(NSArray *)playlistGuids{

    self = [super init];
    if(self){
        self.guid = guid;
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        self.startDate = [dateFormatter dateFromString:startDate];
        self.endDate = [dateFormatter dateFromString:endDate];
        self.playlistsValidity = [playlistsValidity integerValue];
        self.imageUri = imageUri;
        self.playlistGuids = playlistGuids;
    }
    return self;
}

-(NSString *)startDateAsString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *result = [dateFormatter stringFromDate:self.startDate];
    [dateFormatter release];
    
    return result;
}

-(NSString *)playlistsExpiryDateAsString{
    NSDate *expiryDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * self.playlistsValidity) sinceDate:self.startDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *result = [dateFormatter stringFromDate:expiryDate];
    [dateFormatter release];
    
    return result;
}

- (void)dealloc {
    [self.guid release];
    [self.startDate release];
    [self.endDate release];
    [self.imageUri release];
    [self.playlistGuids release];
    [super dealloc];
}

@end
