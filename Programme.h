//
//  Programme.h
//  SuperOwlWeeklyHoots
//
//  Created by Abdel Saleh on 20/06/2011.
//  Copyright 2011 Said.fm Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Programme : NSObject {
    NSString *_title;
    NSString *_duration;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *duration;

-(Programme *)initWithTitle:(NSString *)title duration:(NSString *)duration;
@end
