//
//  AudioDownloads.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 06/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "AudioDownloadsManager.h"


@implementation AudioDownloadsManager

@synthesize programmeSyncedCallbackBlock;
+ (id)manager
{
	return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    [self.programmeSyncedCallbackBlock release];
    [super dealloc];
}

@end
