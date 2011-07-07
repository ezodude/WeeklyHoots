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

-(void)prepareDownloadContextForBundle:(WeeklyBundle *)bundle{
    NSLog(@"prepareDownloadContextForBundle");
    NSString *basePath = [FileStore applicationDocumentsDirectory];
    if(!basePath) return;    
}

-(void)startDownloadsForBundle:(WeeklyBundle *)bundle progressView:(UIProgressView *)progressView withCallback:(ProgrammeSyncedCallbackBlock)block{
    NSLog(@"startDownloadsForBundle");
    [self setProgrammeSyncedCallbackBlock:block];
}
@end
