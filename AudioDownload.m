//
//  AudioDownload.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 06/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "AudioDownload.h"


@implementation AudioDownload

@synthesize bundle=_bundle;
@synthesize playlist=_playlist;
@synthesize programme=_programme;
@synthesize downloadPath=_downloadPath;
@synthesize downloadFile=_downloadFile;
@synthesize tempDownloadFile=_tempDownloadFile;

@synthesize requestFinishedCallbackBlock;

+(NSString *)audioDownloadPathFromBundle:(WeeklyBundle *)bundle playlist:(Playlist *)playlist {
    return [NSString stringWithFormat:@"%@/%@/%@/%@", [FileStore applicationDocumentsDirectory], AUDIO_DIR, [bundle guid], [playlist guid]];
}

+(NSString *)audioDownloadFilenameFromProgramme:(Programme *)programme {
    return [NSString stringWithFormat:@"%@.%@", [programme guid], [programme audioType]];
}

-(AudioDownload *)initWithBundle:(WeeklyBundle *)bundle playlist:(Playlist *)playlist programme:(Programme *)programme withRequestFinishedCallback:(RequestFinishedCallbackBlock)block{
    
    self = [super init];
    if (self) {
        self.bundle = bundle;
        self.playlist = playlist;
        self.programme = programme;
        
        self.downloadPath = [AudioDownload audioDownloadPathFromBundle:bundle playlist:playlist];

        self.downloadFile = [self.downloadPath stringByAppendingFormat:@"/%@", [AudioDownload audioDownloadFilenameFromProgramme:programme]];
        
        self.tempDownloadFile = [NSString stringWithFormat:@"%@.download", self.downloadFile];
        
        [self setRequestFinishedCallbackBlock:block];
    }
    
    [self.programme setToMarkedForDownload];
    
    return self;
}

-(ASIHTTPRequest *)generateRequest{
    NSLog(@"Generate Request for: [%@]", [self.programme audioUri]);
    NSURL *url = [NSURL URLWithString:[self.programme audioUri]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:self.downloadFile];
    [request setTemporaryFileDownloadPath:self.tempDownloadFile];
    [request setAllowResumeForFileDownloads:YES];
    
    [request setStartedBlock:^{
        NSLog(@"Request starting!");
        [self createDownloadPathOnDisk];
        [self.programme setToDownloading];
    }];
    
    [request setCompletionBlock:^{
        NSLog(@"Starting setCompletionBlock for Bundle [%@], Playlist [%@], [%@]", [self.bundle startDate], [self.playlist title], [self.programme audioUri]);
        [self.programme setToDownloaded];
        self.programme.downloadFilename = self.downloadFile;
        
        self.requestFinishedCallbackBlock();
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Starting **setFailedBlock** for Bundle [%@], Playlist [%@], [%@]", [self.bundle startDate], [self.playlist title], [self.programme audioUri]);
        [self.programme setToNotDownloaded]; /* Or Failed Download? */
    }];
    
    return request;
}

-(void)createDownloadPathOnDisk{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    [manager createDirectoryAtPath:self.downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)dealloc {
    [self.bundle release];
    [self.playlist release];
    [self.programme release];
    [self.downloadPath release];
    [self.downloadFile release];
    [self.tempDownloadFile release];
    [self.requestFinishedCallbackBlock release];
    [super dealloc];
}
@end
