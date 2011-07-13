//
//  WeeklyBundle.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"

@class Playlist;

@interface WeeklyBundle : NSObject {
    NSString *_guid;
    NSDate *_startDate;
    NSDate *_endDate;
    NSUInteger _durationInMinutes;
    NSArray *_playlists;
    NSUInteger _totalProgrammesCount;
}

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) NSUInteger durationInMinutes;
@property (nonatomic, retain) NSArray *playlists;
@property (nonatomic, assign) NSUInteger totalProgrammesCount;

-(WeeklyBundle *)initFromDictionary:(NSDictionary *)dictionary;
-(WeeklyBundle *)initWithGuid:(NSString *)guid startDate:(NSString *)startDate endDate:(NSString *)endDate durationInMinutes:(NSNumber *)durationInMinutes playlists:(NSArray *)playlists;

-(NSDecimalNumber *)durationInHours;
-(NSUInteger)downloadedProgrammesCount;
-(NSUInteger)programmesAwaitingDownloadCount;

@end
