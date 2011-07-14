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

+(NSString *)createDirectoryPath:(NSString *)path{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

+(NSString *)createDirectoryNamed:(NSString *)name inDir:(NSString *)path{
    NSString *directory = [path stringByAppendingFormat:@"/%@",name];
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    return directory;
}

@end
