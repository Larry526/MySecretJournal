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
@property (strong, nonatomic) UITableView *tableView;
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
//    NSDate *today = [NSDate date];
    
//    CALENDAR INITIALIZATION
    
    self.dataHandler = [[DataHandler alloc]init];
    [self fetchData];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fetchData) name:NSManagedObjectContextDidSaveNotification object:nil];
    
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
    
//  TABLE BELOW CALENDAR
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.tableView aboveSubview:self.tableViewContainer];
}

-(void)fetchData {
    self.journals = [self.dataHandler fetchData];
    [self.tableView reloadData];
}

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

#pragma TABLEVIEW STUFF
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.journals.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSCalendarDefaultCellReuseIdentifier forIndexPath:indexPath];
//    Journal *journal = self.journals[indexPath.row];
//    cell.textLabel.text = @"TEST";
//    cell.textLabel.alpha = 1;
//
//    UILabel *testLabel = [[UILabel alloc] init];
//    testLabel.text = @"TEEEEST";
//    [cell addSubview:testLabel];
//
////    cell.titleLabel.text = journal.title;
////    cell.detailLabel.text = journal.detail;
//
//    return cell;
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
