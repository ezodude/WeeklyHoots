//
//  FileStore.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 03/07/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileStore : NSObject {
    
}

+(NSString *)applicationDocumentsDirectory;
+(NSString *)createDirectoryNamed:(NSString *)name inDir:(NSString *)path;
@end
