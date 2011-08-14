//
//  FailedPlaylist.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 13/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"

@interface FailedPlaylist : Playlist {
    NSString *_localizedErrorDescription;
}

@property (nonatomic, retain) NSString *localizedErrorDescription;

-(id)initFromDictionary:(NSDictionary *)dictionary withLocalizedErrorDescription:(NSString *)localizedErrorDescription;
-(id)initFromDictionary:(NSDictionary *)dictionary;

-(BOOL)hasContent;
-(BOOL)isDisplayable;
@end
