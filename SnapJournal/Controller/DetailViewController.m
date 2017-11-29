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
    self.dvcDetailLabel.text = journal.detail;
    NSURL *imageURL = [NSURL fileURLWithPath:journal.image];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    self.dvcImageView.image = [UIImage imageWithData:imageData];
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
