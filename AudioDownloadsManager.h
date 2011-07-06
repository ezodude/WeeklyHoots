//
//  AudioDownloads.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 06/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgrammeSyncedCallbackBlock)();

@interface AudioDownloadsManager : NSObject {
    
}

@property (nonatomic, copy) ProgrammeSyncedCallbackBlock programmeSyncedCallbackBlock;

+ (id)manager;

@end
