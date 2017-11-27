//
//  CalendarViewController.h
//  SnapJournal
//
//  Created by Murat Ekrem Kolcalar on 11/27/17.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDTSimpleCalendar/PDTSimpleCalendar.h>

@interface CalendarViewController : PDTSimpleCalendarViewController <PDTSimpleCalendarViewDelegate>

@property (nonatomic, strong) UIColor *backgroundColor;

@end
