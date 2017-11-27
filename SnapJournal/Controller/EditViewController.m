//
//  EditViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    NSString *title = self.titleTextField.text;
    NSString *content = self.contentTextView.text;
    NSString *imgURL =@"test URL";
    NSDictionary *data = @{@"title": title};
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
