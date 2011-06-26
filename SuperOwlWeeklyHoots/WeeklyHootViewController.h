//
//  FirstViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 17/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeeklyHootSectionHeader.h"
#import "ASIHTTPRequest.h"

@class WeeklyBundle;
@class WeeklyHootSectionHeader;

@interface WeeklyHootViewController : UITableViewController {
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_lastBundle;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *lastBundle;

- (void)grabURLInBackground:(NSString *)urlPath;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end
