//
//  CalendarViewController.m
//  SnapJournal
//
//  Created by Murat Ekrem Kolcalar on 11/27/17.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "CalendarViewController.h"
#import "DetailViewController.h"
#import "DataHandler.h"
#import "Journal+CoreDataClass.h"
#import "CustomTableViewCell.h"

@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, FSCalendarDelegate, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <Journal*>*journals;
@property (strong, nonatomic) DataHandler *dataHandler;

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSArray *datesWithEvent;

@end

@implementation CalendarViewController
@dynamic selectedDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    DATA STUFF
    
    self.dataHandler = [[DataHandler alloc]init];
//    [self fetchData];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fetchData) name:NSManagedObjectContextDidSaveNotification object:nil];
    
//    CALENDAR INITIALIZATION
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    calendar.appearance.eventDefaultColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0];
    calendar.appearance.eventSelectionColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0];
    calendar.appearance.todaySelectionColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0];
    calendar.appearance.selectionColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0];
    calendar.appearance.todayColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0];
    calendar.appearance.headerTitleColor = [UIColor colorWithRed:0.61 green:0.50 blue:0.15 alpha:1.0];
    calendar.appearance.titlePlaceholderColor = [UIColor grayColor];
    calendar.appearance.subtitlePlaceholderColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0];
    calendar.appearance.weekdayTextColor = [UIColor colorWithRed:0.61 green:0.50 blue:0.15 alpha:1.0];
    
    [calendar setScrollDirection:FSCalendarScrollDirectionVertical];
    calendar.backgroundColor = [UIColor whiteColor];
    
}


//-(void)fetchData {
//    self.journals = [self.dataHandler fetchData];
//    [self.tableView reloadData];
//    NSLog(@"%f", self.journals.lastObject.lattitude);
//}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        return 1;
    }
    return 0;
}

- (void) calendarTapped {
    [UIView animateWithDuration:0.5f animations:^{
        self.calendar.frame = CGRectOffset(self.calendar.frame, 0, -100);
    }];
}

- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    return @"Test";
}

#pragma TABLEVIEW STUFF
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.journals.count;
}

-(CalendarTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CalendarCell";
    CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    Journal *journal = self.journals[indexPath.row];
    cell.calendarCellLabel.text = journal.title;
    NSLog(@"Date: %@", journal.timeStamp);

    return cell;
}

//-(void)readSelectedInstall:(NSString *)projIDString
//{
//
//    NSArray *fetchedObjects;
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"timeStamp"  inManagedObjectContext: context];
//    [fetch setEntity:entityDescription];
//    [fetch setPredicate:[NSPredicate predicateWithFormat:@"date = %@",projIDString]];
//    NSError * error = nil;
//    fetchedObjects = [context executeFetchRequest:fetch error:&error];
//
//    if([fetchedObjects count] == 1)
//        return [fetchedObjects objectAtIndex:0];
//    else
//        return nil;
//
//}

#pragma SEGUE TEST STUFF

//- (void)collectionView:(PDTSimpleCalendarViewController *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.item == 0)
//    {
//        [self performSegueWithIdentifier:@"segueToDetailViewController" sender:self];
//    }
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"segueToDetailViewController"])
//    {
//        NSIndexPath *selectedIndexPath = [self.calendarController indexPathForPreferredFocusedViewInCollectionView:sender];
//
//        DetailViewController *destVC = [segue destinationViewController];
//        destVC.selectedDate = self.selectedDate;
//    }
//}

@end
