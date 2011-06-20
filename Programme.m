//
//  Programme.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Programme.h"


@implementation Programme
@synthesize title=_title;
@synthesize duration=_duration;

-(Programme *)initWithTitle:(NSString *)title duration:(NSString *)duration{
    self = [super init];
    if(self){
        self.title = title;
        self.duration = duration;
    }
    return self;
}
@end
