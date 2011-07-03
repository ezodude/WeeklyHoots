//
//  DownloadsManager.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 03/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileStore.h"
#import "WeeklyBundle.h"
#import "Programme.h"

#define AUDIO_DIR @"/Audio"

@interface DownloadsManager : NSObject {
}

-(void)syncBundle:(WeeklyBundle *)bundle;
-(NSString *)createDirectoryNamed:(NSString *)bundle inDir:(NSString *)path;
@end
