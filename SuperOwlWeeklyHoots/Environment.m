//
//  Environment.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 24/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "Environment.h"

@implementation Environment

static Environment *sharedInstance = nil;

@synthesize programmesAPIURL;

- (id)init
{
    self = [super init];
    
    if (self) {
        // Do Nada
    }
    
    return self;
}

- (void)initializeSharedInstance
{
    NSString* configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* envsPListPath = [bundle pathForResource:@
                               "Environments" ofType:@"plist"];
    NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    NSDictionary* environment = [environments objectForKey:configuration];
    
    self.programmesAPIURL = [environment valueForKey:@"programmesAPIURL"];
    [environments release];
}

#pragma mark - Lifecycle Methods

+ (Environment *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            [sharedInstance initializeSharedInstance];
        }
        return sharedInstance;
    }
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (void) release
{
    // Do Nada
}

- (id) autorelease
{
    return self;
}

- (id) retain
{
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end