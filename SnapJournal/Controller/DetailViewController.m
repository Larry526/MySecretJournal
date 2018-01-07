//
//  DetailViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>

@interface DetailViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (weak, nonatomic) IBOutlet UILabel *degreesLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    Journal *journal = self.journal;

    NSDate *currentDate = journal.timeStamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MMMM dd, YYYY";
    self.dateLabel.text = [dateFormatter stringFromDate: currentDate];
    self.dvcTitleLabel.text = journal.title;
    self.dvcTitleLabel.layer.borderWidth = 0.75f;
    self.dvcTitleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.dvcDetailLabel.text = journal.detail;
    self.dvcDetailLabel.layer.borderWidth = 0.75f;
    self.dvcDetailLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.degreesLabel.text = [NSString stringWithFormat:@"%g°C", round(journal.temp)];
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", journal.city, journal.country];
    self.pinIcon.image = [UIImage imageNamed:@"icon_mappin"];
    self.dvcImageView.image = [[UIImage alloc] initWithData:journal.image];
    self.weatherIcon.image = [UIImage imageNamed:journal.condition];
    
    CLLocationCoordinate2D location;
    location.latitude = journal.lattitude;
    location.longitude = journal.longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location;
    [self.mapView addAnnotation: annotation];
    
    MKMapCamera *camera = [MKMapCamera camera];
    camera.centerCoordinate = location;
    camera.altitude = 700;
    self.mapView.camera = camera;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)dismissKeyboard {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Resize view when keyboard appears
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"button_snap.png"] forState:UIControlStateNormal];
        self.dvcTitleLabel.hidden = YES;
        self.dvcDetailLabel.hidden = YES;
        self.titleTextField.hidden = NO;
        self.contentTextView.hidden = NO;
        
        self.titleTextField.text = self.journal.title;
        self.contentTextView.text = self.journal.detail;

        
        
    } else {
            [sender setImage:[UIImage imageNamed:@"button_edit.png"] forState:UIControlStateNormal];
        self.dvcTitleLabel.hidden = NO;
        self.dvcDetailLabel.hidden = NO;
        self.titleTextField.hidden = YES;
        self.contentTextView.hidden = YES;
        
        self.journal.title = self.titleTextField.text;
        self.journal.detail = self.contentTextView.text;
        [self.context save:NULL];
        [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

    


@end
