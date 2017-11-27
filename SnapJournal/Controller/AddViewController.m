//
//  EditViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSManagedObjectContext *context;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    NSString *title = self.titleTextField.text;
    NSString *detail = self.contentTextView.text   ;
    NSString *image =@"test URL";
    NSDate *currentDate = [NSDate date];
    NSLog(@"%@",currentDate);
    NSDictionary *results = @{@"title": title, @"detail": detail, @"image": image, @"date": currentDate};
    
    [self.dataHandler saveJournal:results];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getWeatherButtonPressed:(UIButton *)sender {
    
}

- (IBAction)getLocationButtonPressed:(UIButton *)sender {
}



@end
