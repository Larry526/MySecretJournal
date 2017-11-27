//
//  ViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-25.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "MainViewController.h"
#import "AddViewController.h"
#import "CustomTableViewCell.h"
#import "DataHandler.h"
#import "Date+CoreDataClass.h"
#import "Journal+CoreDataClass.h"
#import "DateHandler.h"

@interface MainViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <Journal*>*journals;
@property (strong, nonatomic) DataHandler *dataHandler;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataHandler = [[DataHandler alloc]init];
    [self fetchData];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(fetchData) name:NSManagedObjectContextDidSaveNotification object:nil];
}

-(void)fetchData {
    self.journals = [self.dataHandler fetchData];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddJournal"]) {
        AddViewController *avc = segue.destinationViewController;
        avc.dataHandler = self.dataHandler;
    }
}


#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.journals.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    Date *date = self.dates[indexPath.section];
    Journal *journal = self.journals[indexPath.row];
    cell.titleLabel.text = journal.title;
    cell.detailLabel.text = journal.detail;

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@", self.journals[section].timeStamp];
}


@end
