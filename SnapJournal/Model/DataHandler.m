//
//  DataHandler.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "DataHandler.h"

@interface DataHandler()

@property (nonatomic, weak) AppDelegate *delegate;
@property (nonatomic) NSManagedObjectContext *context;

@end

@implementation DataHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.context = self.delegate.persistentContainer.viewContext;
    }
    return self;
}

-(void)saveJournal:(NSDictionary *)dict {
    Journal *journal = [[Journal alloc]initWithContext:self.context];
    journal.title = dict[@"title"];
    journal.detail = dict[@"detail"];
    journal.image = dict[@"image"];
    journal.weather = dict[@"weather"];
    journal.longitude =  [dict[@"longitude"] doubleValue];
    journal.lattitude =  [dict[@"lattitude"] doubleValue];
    journal.date = dict[@"date"];
    [self.delegate saveContext];
}

@end
