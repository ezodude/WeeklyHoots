//
//  PlaylistsQueue.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlaylistsQueue : NSObject {
    NSString *_guid;
    NSDate *_startDate;
    NSDate *_endDate;
    NSInteger _playlistsValidity;
    NSString *_imageUri;
    NSArray *_playlistGuids;
}

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) NSInteger playlistsValidity;
@property (nonatomic, retain) NSString *imageUri;
@property (nonatomic, retain) NSArray *playlistGuids;

- (id)initFromDictionary:(NSDictionary *)dictionary;
- (PlaylistsQueue *)initWithGuid:(NSString *)guid startDate:(NSString *)startDate endDate:(NSString *)endDate playlistsValidity:(NSNumber *)playlistsValidity imageUri:(NSString *)imageUri playlistGuids:(NSArray *)playlistGuids;

-(NSString *)startDateAsString;
-(NSString *)playlistsExpiryDateAsString;
@end
