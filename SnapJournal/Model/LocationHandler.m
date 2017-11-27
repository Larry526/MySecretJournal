//
//  LocationHandler.m
//  SnapJournal
//
//  Created by Larry Luk on 2017-11-27.
//  Copyright © 2017 Larry Luk. All rights reserved.
//

#import "LocationHandler.h"
#import <Mapkit/Mapkit.h>

@interface LocationHandler () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationHandler

- (void)enableLocationFeatures: (MKMapView*)mapView {
    [self.locationManager startUpdatingLocation];
    mapView.showsUserLocation = YES;
}

- (void)disableLocationFeatures: (MKMapView*)mapView {
    [self.locationManager stopUpdatingLocation];
    mapView.showsUserLocation = NO;
}


- (void)enableLocationServices: (MKMapView*)mapView {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    switch (CLLocationManager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self enableLocationServices:mapView];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self enableLocationServices:mapView];
            break;
    }
}



@end
