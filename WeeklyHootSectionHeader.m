//
//  WeeklyHootSectionHeader.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 21/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "WeeklyHootSectionHeader.h"


@implementation WeeklyHootSectionHeader
@synthesize startToEndDateLabel=_startToEndDateLabel;
@synthesize durationLabel=_durationLabel;
@synthesize syncButton=_syncButton;

-(void)dealloc{
    [self.startToEndDateLabel release];
    [self.durationLabel release];
    [self.syncButton release];
    [super dealloc];
}

@end
