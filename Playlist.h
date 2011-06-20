//
//  Playlist.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Playlist : NSObject {
    NSString *_title;
    NSString *_storyJockey;
    NSString *_summary;
    NSString *_duration;
    NSString *_publicationDate;
    NSArray *_programmes;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *storyJockey;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *publicationDate;
@property (nonatomic, retain) NSArray *programmes;
@end
