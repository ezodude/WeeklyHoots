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

-(WeeklyBundle *)initWithStartDate:(NSString *)startDate endDate:(NSString *)endDate durationInHours:(NSString *)durationInHours playlists:(NSArray *)playlists{
    self = [super init];
    if(self){
        self.startDate = startDate;
        self.endDate = endDate;
        self.durationInHours = durationInHours;
        self.playlists = playlists;
    }
    return self;
}
@end
