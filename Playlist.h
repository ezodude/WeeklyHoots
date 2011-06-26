//
//  Playlist.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Programme.h"
@class Programme;

@interface Playlist : NSObject {
    NSString *_title;
    NSString *_storyJockey;
    NSString *_summary;
    NSNumber *_duration;
    NSString *_publicationDate;
    NSArray *_programmes;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *storyJockey;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSString *publicationDate;
@property (nonatomic, retain) NSArray *programmes;

-(Playlist *)initWithTitle:(NSString *)title 
                storyJockey:(NSString *)storyJockey 
                summary:(NSString *)summary duration:(NSNumber *)duration
                programmes:(NSArray *)programmes;
@end
