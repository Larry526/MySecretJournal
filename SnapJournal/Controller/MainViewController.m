//
//  ViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-25.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "DetailViewController.h"
#import "CustomTableViewCell.h"
#import "DataHandler.h"
#import "Journal+MonthSection.h"
#import "Journal+CoreDataClass.h"

@interface MainViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataHandler *dataHandler;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataHandler = [[DataHandler alloc]init];
    self.fetchedResultsController = [self.dataHandler fetchedResultsController];
    self.fetchedResultsController.delegate = self;

    self.tableView.pagingEnabled = YES;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddJournal"]) {
        AddViewController *avc = segue.destinationViewController;
        avc.dataHandler = self.dataHandler;
    }
    else if ([segue.identifier isEqualToString:@"Details"]) {
        DetailViewController *dvc = segue.destinationViewController;
        dvc.dataHandler = self.dataHandler;
        dvc.context = [self.fetchedResultsController managedObjectContext];
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        dvc.journal = [self.fetchedResultsController objectAtIndexPath:path];
        
    }
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.textLabel.text = header.textLabel.text.uppercaseString;
    header.contentView.backgroundColor = [UIColor colorWithRed:0.57 green:0.45 blue:0.17 alpha:1.0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Journal* journal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = journal.title.uppercaseString;
    cell.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:25];
    cell.titleLabel.textColor = [UIColor blackColor];
    
    cell.detailLabel.text = journal.detail;
    cell.detailLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    cell.detailLabel.textColor = [UIColor blackColor];
    
    NSDate *currentDate = journal.timeStamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MMMM dd, YYYY";
    cell.dateLabel.text = [dateFormatter stringFromDate: currentDate];
    cell.dateLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:16];
    cell.dateLabel.textColor = [UIColor blackColor];
    
    cell.locationLabel.text = [NSString stringWithFormat:@"%@, %@", journal.city, journal.country];
    cell.locationLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    cell.locationLabel.textColor = [UIColor blackColor];
    
    cell.tempLabel.text = [NSString stringWithFormat:@"%g°C", round(journal.temp)];
    cell.tempLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    cell.tempLabel.textColor = [UIColor blackColor];
    cell.weatherIcon.image = [UIImage imageNamed:journal.condition];
    
    
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:journal.image];
    NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageWithData:imageData] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageWithData:imageData] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.backgroundView.alpha = 0.6;
    cell.selectedBackgroundView.alpha = 0.6;
    
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    visualEffectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, cell.titleLabel.bounds.size.height * 2.75);
//    [visualEffectView.layer setCornerRadius:10.f];
//    [cell.backgroundView addSubview:visualEffectView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height/4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].name;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
