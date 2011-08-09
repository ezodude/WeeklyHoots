//
//  ProgrammeDownload.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 03/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "ProgrammeDownload.h"


@implementation ProgrammeDownload

@synthesize programme=_programme;
@synthesize downloadPath=_downloadPath;
@synthesize downloadFile=_downloadFile;
@synthesize tempDownloadFile=_tempDownloadFile;
@synthesize downloadDelegate=_downloadDelegate;

-(ProgrammeDownload *)initWithProgramme:(Programme *)programme downloadPath:(NSString *)downloadPath delegate:(id)delegate{
    self = [super init];
    if (self) {
        self.programme = programme;
        self.downloadPath = downloadPath;
        self.downloadDelegate = delegate;
        
        self.downloadFile = [self.downloadPath stringByAppendingFormat:@"/%@", programme.downloadFilename];
        
        self.tempDownloadFile = [NSString stringWithFormat:@"%@.download", self.downloadFile];
    }
    
    [self.programme setToMarkedForDownload];
    
    return self;
}

-(BOOL)hasNotBeenDownloaded{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    return ![manager fileExistsAtPath:self.downloadFile];;
}

-(ASIHTTPRequest *)generateRequest{
    NSLog(@"Generate Audio Download Request for: [%@]", [self.programme audioUri]);
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
        NSLog(@"Starting setCompletionBlock for programme title: [%@] uri: [%@]", [self.programme title], [self.programme audioUri]);
        [self.programme setToDownloaded];
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Starting **setFailedBlock** for programme title: [%@] uri: [%@], Error: [%@]", [self.programme title], [self.programme audioUri], [error description]);
        
        [self.programme setToNotDownloaded]; /* Or Failed Download? */
        
        if([[error domain] isEqualToString:@"ASIHTTPRequestErrorDomain"] && [error code] != 4)
            [self.downloadDelegate downloadErrorForProgrammeDownload:self error:[request error]];
    }];
    
    return request;
}

-(void)createDownloadPathOnDisk{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    [manager createDirectoryAtPath:self.downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)dealloc {
    [self.programme release];
    [self.downloadPath release];
    [self.downloadFile release];
    [self.tempDownloadFile release];
    [self.downloadDelegate release];
    [super dealloc];
}

@end
