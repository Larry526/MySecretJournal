//
//  DetailViewController.h
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "MainViewController.h"
#import "DataHandler.h"

@interface DetailViewController : MainViewController

@property (strong, nonatomic) NSDate *selectedDate;
@property (nonatomic) Journal *journal;
@property (nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UILabel *dvcTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dvcDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dvcImageView;

@end
