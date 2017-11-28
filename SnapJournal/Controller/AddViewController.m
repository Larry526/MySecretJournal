//
//  EditViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "AddViewController.h"
#import <Mapkit/Mapkit.h>
#import "WeatherAPI.h"

@interface AddViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSNumber *storedLong;
@property (strong, nonatomic) NSNumber *storedLat;

@property (strong, nonatomic) UIImage *testImage;
@property (strong, nonatomic) NSString *imageURL;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableLocationServices];

}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    NSString *title = self.titleTextField.text;
    NSString *detail = self.contentTextView.text;
    NSString *image = self.imageURL;
    NSDate *currentDate = [NSDate date];
    NSLog(@"%@",currentDate);
    NSDictionary *results = @{@"title": title, @"detail": detail, @"image": image, @"date": currentDate, @"longitude": self.storedLat, @"lattitude": self.storedLat};
    [self.dataHandler saveJournal:results];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Getter

- (IBAction)getImageButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // not running on simulator, take a picture
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    NSLog(@"Picking media of types: %@", mediaTypes);
    picker.mediaTypes = mediaTypes;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
    
}

- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    NSLog(@"Info: %@", info);
    self.testImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = self.testImage;
    
    self.imageURL = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]] stringByAppendingPathExtension:@"png"];
//    NSData *imageData = UIImagePNGRepresentation(self.testImage);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)getWeatherButtonPressed:(UIButton *)sender {
    
}

- (IBAction)getLocationButtonPressed:(UIButton *)sender {
}

#pragma mark - CLLocation and Map

- (void)enableLocationServices {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    switch (CLLocationManager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self disableLocationFeatures];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self enableLocationFeatures];
            break;
    }
}

- (void)enableLocationFeatures {
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
}

- (void)disableLocationFeatures {
    [self.locationManager stopUpdatingLocation];
    self.mapView.showsUserLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self enableLocationFeatures];
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self disableLocationFeatures];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusNotDetermined:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    for (CLLocation *location in locations) {
        NSLog(@"Found Location: (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
        self.storedLat = @(location.coordinate.latitude);
        self.storedLong = [NSNumber numberWithDouble:location.coordinate.longitude];
        MKMapCamera *camera = [MKMapCamera camera];
        camera.centerCoordinate = location.coordinate;
        camera.altitude = 700;
        self.mapView.camera = camera;
        [self.locationManager stopUpdatingLocation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        view.animatesDrop = YES;
        view.canShowCallout = YES;
    } else {
        view.annotation = annotation;
    }
    
    return view;
}


@end
