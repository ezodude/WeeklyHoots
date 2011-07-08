//
//  AudioDownloads.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 06/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeeklyBundle.h"
#import "AudioDownload.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "FileStore.h"

@class ASINetworkQueue;
@class ASIHTTPRequest;
@class WeeklyBundle;
@class AudioDownload;

typedef void (^CompletionCallbackBlock)();

@interface AudioDownloadsManager : NSObject {
    ASINetworkQueue *_audioDownloadsQueue;
}

@property (nonatomic, copy) CompletionCallbackBlock allDownloadsCompleteBlock;

+(id)manager;

-(void)prepareDownloadContextForBundle:(WeeklyBundle *)bundle progressView:(UIProgressView *)progressView withProgressCallback:(CompletionCallbackBlock)block;

-(void)startDownloadsForBundle:(WeeklyBundle *)bundle withCompletionCallback:(CompletionCallbackBlock)block; 

@end
