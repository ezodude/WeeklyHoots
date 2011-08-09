//
//  Programme.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNotDownloaded,
    kMarkedFordownload,
    kDownloaded,
    kDownloading
} DownloadStatus;

@interface Programme : NSObject {
    NSString *_guid;
    NSString *_title;
    NSUInteger _duration;
    NSString *_audioUri;
    NSString *_audioType;
    NSString *_downloadFilename;
    
    DownloadStatus _downloadStatus;
}

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, retain) NSString *audioUri;
@property (nonatomic, retain) NSString *audioType;
@property (nonatomic, retain) NSString *downloadFilename;

-(Programme *)initWithGuid:(NSString *)guid title:(NSString *)title duration:(NSNumber *)duration audioURI:(NSString *)audioUri;

-(void)setToNotDownloaded;
-(void)setToMarkedForDownload;
-(void)setToDownloading;
-(void)setToDownloaded;

-(BOOL)downloaded;
-(BOOL)downloading;
-(BOOL)markedForDownload;

-(NSDictionary *)dictionaryFromObject;
@end
