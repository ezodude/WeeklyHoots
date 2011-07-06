//
//  Programme.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Programme : NSObject {
    NSString *_guid;
    NSString *_title;
    NSUInteger _duration;
    NSString *_audioUri;
    NSString *_audioType;

    BOOL _downloaded;
    BOOL _downloading;
    BOOL _markedFordownloaded;
}

@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, retain) NSString *audioUri;
@property (nonatomic, retain) NSString *audioType;

@property (nonatomic, assign) BOOL downloaded;
@property (nonatomic, assign) BOOL downloading;
@property (nonatomic, assign) BOOL markedFordownloaded;

-(Programme *)initWithGuid:(NSString *)guid title:(NSString *)title duration:(NSNumber *)duration audioURI:(NSString *)audioUri;
@end
