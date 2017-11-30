//
//  Journal+MonthSection.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-28.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "Journal+MonthSection.h"

@implementation Journal (MonthSection)

- (NSString*) month {
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    fmtr.timeStyle = NSDateFormatterNoStyle;
    fmtr.dateFormat = @"MMMM YYYY";
    return [fmtr stringFromDate:self.timeStamp];
}

@end
