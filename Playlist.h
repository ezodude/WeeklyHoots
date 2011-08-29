//
//  Playlist.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Programme.h"
#import "Storybox.h"
#import "../JSONKit/JSONKit.h"

@class Programme;

#define REFRESH_FREQUENCY 1

@interface Playlist : NSObject {
    NSString *_guid;
    NSString *_title;
    NSString *_storyJockey;
    NSString *_summary;
    NSUInteger _duration;
    NSDate *_publicationDate;
    NSArray *_programmes;
    
    NSDate *_dateQueued;
    NSDate *_expiryDate;
}

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *storyJockey;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, retain) NSDate *publicationDate;
@property (nonatomic, retain) NSArray *programmes;
@property (nonatomic, retain) NSDate *dateQueued;
@property (nonatomic, retain) NSDate *expiryDate;


-(id)initFromDictionary:(NSDictionary *)dictionary;

-(id)initWithGuid:(NSString *)guid 
                title:(NSString *)title 
                storyJockey:(NSString *)storyJockey 
                summary:(NSString *)summary 
                duration:(NSNumber *)duration 
                dateQueued:(NSString *) dateQueued
                programmes:(NSArray *)programmes;

-(NSString *)pathOnDisk;
-(NSString *)audioDownloadsPath;
-(NSArray *)downloadFilepathsForProgrammes;

-(BOOL)isExpired;
-(NSInteger)numberOfDaysBeforeExpiry;
-(BOOL)hasCompleteDownloads;

-(NSDictionary *)dictionaryFromObject;
-(NSData *)JSONData;

-(BOOL)hasContent;
-(BOOL)isDisplayable;
-(BOOL)hasErrors;
@end
