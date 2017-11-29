//
//  DetailViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "DetailViewController.h"
#import "DataHandler.h"

@interface DetailViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataHandler = [[DataHandler alloc]init];
    self.fetchedResultsController = [self.dataHandler fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    Journal *journal = self.fetchedResultsController.fetchedObjects[0];
    
    self.dvcTitleLabel.text = journal.title;
    self.dvcDetailLabel.text = journal.description;
    self.dvcImageView.image = [UIImage imageWithData:journal.image];
    NSData *imageData = [NSData dataWithContentsOfFile:journal.image];
//    NSURL *imageURL = [NSURL URLWithString:journal.image];
    self.dvcImageView.image = [NSData dataWithContentsOfURL:imageData];
    
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
