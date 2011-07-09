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
@synthesize pauseDownloadsCompleteBlock;

-(id)init {
    self = [super init];
    
    if (self) {
        _audioDownloadsQueue = [[ASINetworkQueue alloc] init];
        
        [_audioDownloadsQueue setDelegate:self];
        [_audioDownloadsQueue setMaxConcurrentOperationCount:3];
        [_audioDownloadsQueue setShouldCancelAllRequestsOnFailure:NO];
        [_audioDownloadsQueue setQueueDidFinishSelector:@selector(allDownloadsCompleted)];
        [_audioDownloadsQueue setShouldCancelAllRequestsOnFailure:NO];
//        [_audioDownloadsQueue setShowAccurateProgress:YES];
    }
    return self;
}

+(id)manager{
	return [[self alloc] init];
}

-(void)dealloc {
    [_audioDownloadsQueue release];
    [self.allDownloadsCompleteBlock release];
    [self.pauseDownloadsCompleteBlock release];
    [super dealloc];
}

-(void)prepareDownloadContextForBundle:(WeeklyBundle *)bundle progressView:(UIProgressView *)progressView withProgressCallback:(CompletionCallbackBlock)block{
    NSLog(@"prepareDownloadContextForBundle");
    
    [_audioDownloadsQueue setDownloadProgressDelegate:progressView];
    __block NSMutableArray *audioDownloads = [[NSMutableArray alloc] init];
    
    [bundle.playlists enumerateObjectsUsingBlock:^(id playlist, NSUInteger idx, BOOL *stop) {
        [[playlist programmesAwaitingDownload] enumerateObjectsUsingBlock:^(id prog, NSUInteger idx, BOOL *stop) {
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


-(void)pauseSyncing:(WeeklyBundle *)bundle withCompletionCallback:(CompletionCallbackBlock)block{
    NSLog(@"pause Syncing for bundle");
    
    [self setAllDownloadsCompleteBlock:nil];
    [self setPauseDownloadsCompleteBlock:block];
    
    [_audioDownloadsQueue cancelAllOperations];
}

-(void)allDownloadsCompleted{
    if(self.allDownloadsCompleteBlock) self.allDownloadsCompleteBlock();
}

@end
