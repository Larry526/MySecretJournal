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

@interface MainViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <Date*>*dates;
@property (strong, nonatomic) DataHandler *dataHandler;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataHandler = [[DataHandler alloc]init];
    [self fetchData];
}

-(void)fetchData {
    self.dates = [self.dataHandler fetchData];
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
    return self.dates.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = @"Hello World!";

    return cell;
    
}


@end
