//
//  FailedPlaylist.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 13/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"

@class Playlist;

@interface FailedPlaylist : Playlist {
    NSError *_error;
}

@property (nonatomic, retain) NSError *error;

-(BOOL)hasContent;
-(BOOL)isDisplayable;
@end
