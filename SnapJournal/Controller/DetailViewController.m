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
//
//    self.dataHandler = [[DataHandler alloc]init];
//    self.fetchedResultsController = [self.dataHandler fetchedResultsController];
//    self.fetchedResultsController.delegate = self;
//
//    NSError *error = nil;
//    if (![self.fetchedResultsController performFetch:&error]) {
//
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//
    Journal *journal = self.journal;
//
    self.dvcTitleLabel.text = journal.title;
    self.dvcDetailLabel.text = journal.detail;
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:journal.image];
    NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
    self.dvcImageView.image = [[UIImage alloc] initWithData:imageData];
    
    
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
