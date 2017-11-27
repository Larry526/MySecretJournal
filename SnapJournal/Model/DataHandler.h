//
//  DataHandler.h
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Date+CoreDataClass.h"
#import "Journal+CoreDataClass.h"

@interface DataHandler : NSObject

-(void)saveJournal:(NSDictionary*) dict;
-(NSArray<Journal *>*) fetchData;


@end
