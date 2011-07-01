//
//  BundlesManager.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 30/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "BundlesManager.h"

// Private stuff
@interface BundlesManager ()
-(void)bundleSetupComplete;
-(void)queueBundle:(NSString *)bundleType;
-(void)processBundle:(NSString *)bundleType fromRequest:(ASIHTTPRequest *)request;
-(void)processFailureForBundle:(NSString *)bundleType fromRequest:(ASIHTTPRequest *)request;
@end

@implementation BundlesManager

@synthesize recentBundle = _recentBundle;
@synthesize currentBundle = _currentBundle;
@synthesize bundleSetupSuccessCallbackBlock;

- (id)init {
    self = [super init];
    
    if (self) {
        _programmesAPIURL = [[Environment sharedInstance] programmesAPIURL];
        
        _bundlesRequestQueue = [ASINetworkQueue queue];
        [_bundlesRequestQueue setDelegate:self];
        [_bundlesRequestQueue setQueueDidFinishSelector:@selector(bundleSetupComplete)];
    }
    return self;
}

+ (id)manager
{
	return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    [_programmesAPIURL release];
    [_bundlesRequestQueue release];
    
    [self.bundleSetupSuccessCallbackBlock release];
    [self.recentBundle release];
    [self.currentBundle release];
    
    [super dealloc];
}

-(void)setupBundlesWithCallback:(BundleSetupSuccessCallbackBlock)block{
    [_bundlesRequestQueue cancelAllOperations];
    [self setBundleSetupSuccessCallbackBlock:block];
    
    [self queueBundle:@"Recent"];
    [self queueBundle:@"Current"];
    
    [_bundlesRequestQueue go];
}

-(BOOL)bundlesAreAvailable{
    return (self.recentBundle && self.currentBundle);
}

-(void)bundleSetupComplete{
    self.bundleSetupSuccessCallbackBlock();
}

- (void)queueBundle:(NSString *)bundleType{
    NSLog(@"Grabbing Bundle: [%@]", bundleType);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@bundles/%@.json", _programmesAPIURL, [bundleType lowercaseString]]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setCompletionBlock:^{
        NSLog(@"Starting setCompletionBlock for: [%@]", bundleType);
        [self processBundle:bundleType fromRequest:request];
    }];
    
    [request setFailedBlock:^{
        NSLog(@"Starting setFailedBlock for: [%@]", bundleType);
        [self processFailureForBundle:bundleType fromRequest:request];
    }];
    
    [_bundlesRequestQueue addOperation:request];
}

-(void)processBundle:(NSString *)bundleType fromRequest:(ASIHTTPRequest *)request{
    NSLog(@"Processing Bundle for: [%@]", bundleType);
    
    NSString *responseString = [request responseString];
    NSDictionary *dictionary = (NSDictionary *)[responseString objectFromJSONString];
    
    WeeklyBundle *bundle = [[WeeklyBundle alloc] initFromDictionary:dictionary];
    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@Bundle:", bundleType]) withObject:bundle];
    [bundle release];
}

-(void)processFailureForBundle:(NSString *)bundleType fromRequest:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"Error processing %@: %@", bundleType, [error localizedDescription]);
}

@end