//
//  FailedPlaylist.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 13/08/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "FailedPlaylist.h"

@implementation FailedPlaylist

@synthesize localizedErrorDescription=_localizedErrorDescription;

-(id)initFromDictionary:(NSDictionary *)dictionary withLocalizedErrorDescription:(NSString *)localizedErrorDescription{
    self = [super initFromDictionary:dictionary];
    if (self) {
        self.localizedErrorDescription = localizedErrorDescription;
    }
    return self;
}

-(id)initFromDictionary:(NSDictionary *)dictionary{
    return [self initFromDictionary:dictionary withLocalizedErrorDescription:[dictionary objectForKey:@"error"]];
}

-(BOOL)hasContent{
    return self.title != nil && self.storyJockey != nil && self.duration != 0 && self.dateQueued != nil && self.programmes != nil;
}

-(NSDictionary *)dictionaryFromObject{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryFromObject]];
    [result setObject:self.localizedErrorDescription forKey:@"error"];
    return result;
}

- (void)dealloc {
    [self.localizedErrorDescription release];
    [super dealloc];
}

@end
