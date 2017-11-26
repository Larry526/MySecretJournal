//
//  DateHandler.h
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandler : NSObject

@property (nonnull, strong) NSDate *currentDate;

-(void) returnCurrentDate;

@end
