//
//  AudioDownloads.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 06/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "AudioDownloadsManager.h"

@implementation AudioDownloadsManager

@synthesize allDownloadsCompleteBlock;

-(id)init {
    self = [super init];
    
    if (self) {
        _audioDownloadsQueue = [ASINetworkQueue queue];
        
        [_audioDownloadsQueue setDelegate:self];
        [_audioDownloadsQueue setMaxConcurrentOperationCount:3];
        [_audioDownloadsQueue setShouldCancelAllRequestsOnFailure:NO];
        [_audioDownloadsQueue setQueueDidFinishSelector:@selector(allDownloadsCompleted)];
        [_audioDownloadsQueue setShowAccurateProgress:YES];
    }
    return self;
}

+(id)manager{
	return [[[self alloc] init] autorelease];
}

-(void)dealloc {
    [_audioDownloadsQueue release];
    [self.allDownloadsCompleteBlock release];
    [super dealloc];
}

-(void)prepareDownloadContextForBundle:(WeeklyBundle *)bundle progressView:(UIProgressView *)progressView withProgressCallback:(CompletionCallbackBlock)block{
    NSLog(@"prepareDownloadContextForBundle");
    
    [_audioDownloadsQueue setDownloadProgressDelegate:progressView];
    __block NSMutableArray *audioDownloads = [[NSMutableArray alloc] init];
    
    [bundle.playlists enumerateObjectsUsingBlock:^(id playlist, NSUInteger idx, BOOL *stop) {
        [[playlist programmes] enumerateObjectsUsingBlock:^(id prog, NSUInteger idx, BOOL *stop) {
            [audioDownloads addObject:[[[AudioDownload alloc] initWithBundle:bundle playlist:playlist programme:prog withRequestFinishedCallback:^{
                    block();
            }] autorelease]];
        }];
    }];
    
    [audioDownloads enumerateObjectsUsingBlock:^(id audioDownload, NSUInteger idx, BOOL *stop) {
        [_audioDownloadsQueue addOperation:[(AudioDownload *)audioDownload generateRequest]];
    }];
}

-(void)startDownloadsForBundle:(WeeklyBundle *)bundle withCompletionCallback:(CompletionCallbackBlock)block{
    NSLog(@"startDownloadsForBundle");
    
    [self setAllDownloadsCompleteBlock:block];
    [_audioDownloadsQueue go];
}

-(void)allDownloadsCompleted{
    self.allDownloadsCompleteBlock();
}

@end
