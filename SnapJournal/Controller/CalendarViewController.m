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

@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, FSCalendarDelegate, FSCalendarDataSource, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <Journal*>*journals;
@property (strong, nonatomic) DataHandler *dataHandler;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSArray *datesWithEvent;

@end

@implementation CalendarViewController
@dynamic selectedDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendar.translatesAutoresizingMaskIntoConstraints = YES;
    self.tableView.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.dataHandler = [[DataHandler alloc]init];
    self.fetchedResultsController = [self.dataHandler fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self calendarStarted];
    
}

//- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
//{
//
//}

-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    
// CALENDAR SETUP
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:(NSCalendarUnitYear |
                                               NSCalendarUnitMonth |
                                               NSCalendarUnitDay)
                                     fromDate:date];
    NSDate *dayStart = [cal dateFromComponents:comps];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *dayEnd = [cal dateFromComponents:comps];
    NSPredicate *itemsOnDay = [NSPredicate predicateWithFormat:@"(timeStamp >= %@) AND (timeStamp <= %@)", dayStart, dayEnd];
    [self.fetchedResultsController.fetchRequest setPredicate:itemsOnDay];

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
    
//  NSDATEFORMATTER
    NSDate *selectedDate = date;
    NSDateFormatter *fmtr = [[NSDateFormatter alloc]init];
    [fmtr setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//    [fmtr stringFromDate:selectedDate];
    NSLog(@"Selected Date: %@", [fmtr stringFromDate:selectedDate]);
    
//    GESTURE STUFF
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(calendarTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.calendar addGestureRecognizer:tapGesture];
    
}

- (void) calendarStarted {
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
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
    
    calendar.backgroundColor = [UIColor whiteColor];
    [calendar setScrollDirection:FSCalendarScrollDirectionVertical];
}

- (void) calendarTapped: (CalendarTableViewCell*)sender {
    
    [UIView animateWithDuration:0.5f animations:^{
        self.calendar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
        self.calendar.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
        self.tableView.alpha = 1;
        NSLog(@"Tap gesture success");
    }];
}


- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    return @"";
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailViewController *dvc = segue.destinationViewController;
//        dvc.dataHandler = self.dataHandler;
    }
}

#pragma mark - Table View

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

-(CalendarTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CalendarCell";
    CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    Journal *journal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.calendarCellLabel.text = journal.title;
    
    return cell;
    
}

#pragma mark - Fetched results controller


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
