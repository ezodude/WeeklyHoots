//
//  FailedPlaylist.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 13/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "FailedPlaylist.h"


@implementation FailedPlaylist

@synthesize error=_error;

- (void)dealloc {
    [self.error release];
    [super dealloc];
}

-(BOOL)hasContent{
    return self.title != nil && self.storyJockey != nil && self.duration != 0 && self.dateQueued != nil && self.programmes != nil;
}

-(BOOL)isDisplayable{
    return [self hasContent];
}

@end
