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

-(Programme *)initWithGuid:(NSString *)guid title:(NSString *)title duration:(NSNumber *)duration audioURI:(NSString *)audioUri{
    self = [super init];
    if(self){
        self.guid = guid;
        self.title = title;
        self.duration = duration;
        self.audioUri = audioUri;
        self.audioType = [[[[audioUri componentsSeparatedByString:@"?"] objectAtIndex:0] pathExtension] lowercaseString];
    }
    return self;
}

- (void)dealloc {
    [self.guid release];
    [self.title release];
    [self.duration release];
    [self.audioUri release];
    [super dealloc];
}
@end
