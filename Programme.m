//
//  Programme.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Programme.h"

@implementation Programme

@synthesize guid=_guid;
@synthesize title=_title;
@synthesize duration=_duration;
@synthesize audioUri=_audioUri;
@synthesize audioType=_audioType;
@synthesize downloadFilename=_downloadFilename;

-(Programme *)initWithGuid:(NSString *)guid title:(NSString *)title duration:(NSNumber *)duration audioURI:(NSString *)audioUri{
    self = [super init];
    if(self){
        self.guid = guid;
        self.title = title;
        self.duration = [duration unsignedIntegerValue];
        self.audioUri = audioUri; 
        NSLog(@"audioUri: [%@]", audioUri);
        self.audioType = [[[[audioUri componentsSeparatedByString:@"?"] objectAtIndex:0] pathExtension] lowercaseString];
        self.downloadFilename = [NSString stringWithFormat:@"%@.%@", self.guid, self.audioType];
    }
    [self setToNotDownloaded];
    return self;
}

-(void)setToDownloading{
    _downloadStatus =  kDownloading;
}

-(void)setToDownloaded{
    _downloadStatus =  kDownloaded;
}

-(void)setToNotDownloaded{
    _downloadStatus =  kNotDownloaded;
}

-(void)setToMarkedForDownload{
    _downloadStatus =  kMarkedFordownload;
}

-(BOOL)downloaded{
    return _downloadStatus == kDownloaded;
}

-(BOOL)downloading{
    return _downloadStatus == kDownloading;
}

-(BOOL)markedForDownload{
    return _downloadStatus == kMarkedFordownload;
}

-(NSDictionary *)dictionaryFromObject{
    NSNumber *durationAsNumber = [NSNumber numberWithUnsignedInt:self.duration];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:self.guid, @"id", self.title, @"title", durationAsNumber, @"duration", self.audioUri, @"audioURI", nil];
}

- (void)dealloc {
    [self.guid release];
    [self.title release];
    [self.audioUri release];
    [self.audioType release];
    [self.downloadFilename release];
    [super dealloc];
}
@end
