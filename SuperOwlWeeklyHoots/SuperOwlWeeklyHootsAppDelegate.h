//
//  SuperOwlWeeklyHootsAppDelegate.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 17/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeeklyBundlesNavController;

@interface SuperOwlWeeklyHootsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet WeeklyBundlesNavController *weeklyBundlesNavController;
@end
