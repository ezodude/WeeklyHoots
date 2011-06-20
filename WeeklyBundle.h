//
//  WeeklyBundle.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeeklyBundle : NSObject {
    NSString *_startDate;
    NSString *_endDate;
    NSString *_durationInHours;
    NSArray *_playlists;
}

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, assign) NSString *durationInHours;
@property (nonatomic, retain) NSArray *playlists;

-(WeeklyBundle *)initWithStartDate:(NSString *)startDate endDate:(NSString *)endDate durationInHours:(NSString *)durationInHours playlists:(NSArray *)playlists;

@end
