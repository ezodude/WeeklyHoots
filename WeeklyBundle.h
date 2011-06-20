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
    NSString *_durationInMinutes;
    NSArray *_playlists;
}

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, assign) NSString *durationInMinutes;
@property (nonatomic, retain) NSArray *playlists;

@end
