//
//  ProgrammeDownload.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 03/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Programme.h"
#import "FileStore.h"
#import "ASIHTTPRequest.h"

@class ASIHTTPRequest;

@interface ProgrammeDownload : NSObject {
    Programme *_programme;
    NSString *_downloadPath;
    NSString *_downloadFile;
    NSString *_tempDownloadFile;
    
    id _downloadDelegate;
    
    NSInteger _downloadRetryCount;
}

@property (nonatomic, retain) Programme *programme;
@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSString *downloadFile;
@property (nonatomic, retain) NSString *tempDownloadFile;

@property (nonatomic, retain) id downloadDelegate;

@property (nonatomic, assign) NSInteger downloadRetryCount;

-(ProgrammeDownload *)initWithProgramme:(Programme *)programme downloadPath:(NSString *)downloadPath delegate:(id)delegate;

-(BOOL)hasNotBeenDownloaded;

-(ASIHTTPRequest *)generateRequest;

-(void)createDownloadPathOnDisk;

@end
