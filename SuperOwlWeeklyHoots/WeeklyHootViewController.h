//
//  FirstViewController.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 17/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeeklyBundle;

@interface WeeklyHootViewController : UITableViewController {
    WeeklyBundle *_currentBundle;
    WeeklyBundle *_lastBundle;
}

@property (nonatomic, retain) WeeklyBundle *currentBundle;
@property (nonatomic, retain) WeeklyBundle *lastBundle;
@end
