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
@synthesize imageUri=_imageUri;
@synthesize playlistGuids=_playlistGuids;

- (id)initFromDictionary:(NSDictionary *)dictionary{
    return [self initWithGuid:[dictionary objectForKey:@"id"] startDate: [dictionary objectForKey:@"start_date"] imageUri:[dictionary objectForKey:@"image_uri"] playlistGuids:(NSArray *)[dictionary objectForKey:@"playlist_guids"]];
}

-(PlaylistsQueue *)initWithGuid:(NSString *)guid startDate:(NSString *)startDate imageUri:(NSString *)imageUri playlistGuids:(NSArray *)playlistGuids{    

    self = [super init];
    if(self){
        self.guid = guid;
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        self.startDate = [dateFormatter dateFromString:startDate];
        self.imageUri = imageUri;
        self.playlistGuids = playlistGuids;
    }
    return self;
}

- (BOOL)isFresh{
    return YES;
}

- (NSUInteger)downloadedPlaylistsCount{
    return 0;
}

-(NSString *)nextPlaylistGuidToCollect{
    return nil;
}

-(NSArray *)downloadedPlaylistGuids{
    return nil;
}

- (void)dealloc {
    [self.guid release];
    [self.startDate release];
    [self.imageUri release];
    [self.playlistGuids release];
    [super dealloc];
}

@end
