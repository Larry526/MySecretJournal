//
//  DateHandler.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "DateHandler.h"

@implementation DateHandler

-(void)returnCurrentDate {
    self.currentDate = [NSDate date];
    NSLog(@"Current date is %@", self.currentDate);
    
}


@end