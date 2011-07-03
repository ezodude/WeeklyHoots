//
//  FileStore.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 03/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "FileStore.h"


@implementation FileStore

+(NSString *)applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
}

@end
