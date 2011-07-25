//
//  SuperOwlWeeklyHootsAppDelegate.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 17/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryboxNavController.h"

@class StoryboxNavController;

@interface SuperOwlWeeklyHootsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

//@property (nonatomic, retain) IBOutlet WeeklyBundlesNavController *weeklyBundlesNavController;

@property (nonatomic, retain) IBOutlet StoryboxNavController *storyboxNavController;
@end
