//
//  EditViewController.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-26.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "AddViewController.h"
#import <Mapkit/Mapkit.h>

@interface AddViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) NSNumber *storedLong;
@property (assign, nonatomic) NSNumber *storedLat;




@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableLocationServices];

    
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    NSString *title = self.titleTextField.text;
    NSString *detail = self.contentTextView.text   ;
    NSString *image =@"test URL";
    NSDate *currentDate = [NSDate date];
    NSLog(@"%@",currentDate);
    NSDictionary *results = @{@"title": title, @"detail": detail, @"image": image, @"date": currentDate, @"longitude": self.storedLat, @"lattitude": self.storedLat};
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
    
    for (CLLocation *location in locations) {
        NSLog(@"Found Location: (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
        self.storedLat = [NSNumber numberWithDouble:location.coordinate.latitude];
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
