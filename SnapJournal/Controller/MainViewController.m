//
//  ViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-25.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTableViewCell.h"
#import "DateHandler.h"

@interface MainViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    DateHandler *dateHandler = [[DateHandler alloc]init];
    [dateHandler returnCurrentDate];


}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
