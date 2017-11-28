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
    journal.timeStamp = dict[@"date"];
    [self.delegate saveContext];
}

//-(NSArray<Date *> *)fetchData {
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Journal"];
//    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
//    request.sortDescriptors = @[dateSort];
//    return [self.context executeFetchRequest:request error:nil];
//    
//}

-(NSFetchedResultsController*) fetchedResultsController {

    NSFetchRequest *fetchRequest = [Journal fetchRequest];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timeStamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.context
                                                             sectionNameKeyPath:@"month"
                                                             cacheName:nil];

    return aFetchedResultsController;
}

@end
