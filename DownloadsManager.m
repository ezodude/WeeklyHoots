//
//  DownloadsManager.m
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 03/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import "DownloadsManager.h"


@implementation DownloadsManager

-(void)syncBundle:(WeeklyBundle *)bundle{
    NSString *basePath = [FileStore applicationDocumentsDirectory];
    if(!basePath) return;
    
    NSString *bundleDir = [self createDirectoryNamed:bundle.guid inDir:[basePath stringByAppendingFormat:AUDIO_DIR]];
    
    [[bundle playlists] enumerateObjectsUsingBlock:^(id playlist, NSUInteger idx, BOOL *stop){
        NSString *playlistDir = [self createDirectoryNamed:[playlist guid] inDir:bundleDir];
        
        [[playlist programmes] 
         enumerateObjectsUsingBlock:^(id prog, NSUInteger idx, BOOL *stop){
             NSString *progSyncPath = [NSString stringWithFormat:@"%@/%@.%@", playlistDir, [prog guid], [prog audioType]];
         }];
    }];
    
}

-(NSString *)createDirectoryNamed:(NSString *)name inDir:(NSString *)path{
    NSString *directory = [path stringByAppendingFormat:@"/%@",name];
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    [manager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    return directory;
}

@end
