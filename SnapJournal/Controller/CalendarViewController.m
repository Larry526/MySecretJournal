//
//  CalendarViewController.m
//  SnapJournal
//
//  Created by Murat Ekrem Kolcalar on 11/27/17.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "CalendarViewController.h"
#import "DetailViewController.h"

@interface CalendarViewController ()

@property (strong, nonatomic) PDTSimpleCalendarViewController *calendarController;
@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation CalendarViewController
@dynamic selectedDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *todayDate = [[NSDate alloc]init];
    
    self.calendarController = [[PDTSimpleCalendarViewController alloc]init];
    [self.calendarController setDelegate:self];
    self.calendarController.selectedDate = todayDate;
    self.calendarController.weekdayHeaderEnabled = YES;
    self.calendarController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
    
    [[PDTSimpleCalendarViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    [[PDTSimpleCalendarViewCell appearance] setCircleDefaultColor:[UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:0.0]];
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0]];
    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:1.0]];
    [[PDTSimpleCalendarViewHeader appearance] setSeparatorColor:[UIColor orangeColor]];
    [[PDTSimpleCalendarViewCell appearance] setTextDefaultFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0]];
    [[PDTSimpleCalendarViewCell appearance] setTextDefaultColor:[UIColor colorWithRed:0.54 green:0.45 blue:0.09 alpha:1.0]];
    
    if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
        [self.calendarController setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if (!self.calendarController.selectedDate) {
        NSLog(@"NIL AS FUCK");
    } else {
        NSLog(@"First test: %@", self.calendarController.selectedDate);
    }
    
}


#pragma CALENDAR TEST STUFF

#pragma SEGUE TEST STUFF

- (void)collectionView:(PDTSimpleCalendarViewController *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        [self performSegueWithIdentifier:@"segueToDetailViewController" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToDetailViewController"])
    {
        NSIndexPath *selectedIndexPath = [self.calendarController indexPathForPreferredFocusedViewInCollectionView:sender];
        
        DetailViewController *destVC = [segue destinationViewController];
        destVC.selectedDate = self.selectedDate;
    }
}

@end
