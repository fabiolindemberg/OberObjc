//
//  ViewController.m
//  Ober
//
//  Created by Fabio Lindemberg on 28/07/20.
//  Copyright © 2020 Fabio Lindemberg. All rights reserved.
//

#import "MapViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self configLocation];
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyBoardWasShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWasHide)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    
    // Adding gesture recognizers
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                    action: @selector(dissmissKeyboard)];
    [self.view addGestureRecognizer: tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
}

#pragma mark - Custom Methods

-(void) configLocation
{

    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }else{
        [self beginLocationUpdates:locationManager];
    }
}

- (void) beginLocationUpdates:(CLLocationManager*)locationManager {
    
    self.mapView.showsUserLocation = YES;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
}

- (MKPointAnnotation *) addAnnotationForCoordinate: (CLLocationCoordinate2D) coordinate title: (NSString *) title subtitle: (NSString *) subtitle {
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    [annotation setTitle: title];
    [annotation setSubtitle: subtitle];
    [annotation setCoordinate: coordinate];

    return annotation;
}

- (void) applyZoomToLocation:(CLLocationCoordinate2D) location {
    
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
    
    [self.mapView setRegion: zoomRegion];
}

- (void) setDestinationByText: (NSString *) text {
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder geocodeAddressString: text
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            
            CLLocationCoordinate2D finalLocation = placemarks[0].location.coordinate;
            
            [self.mapView addAnnotation: [self addAnnotationForCoordinate: finalLocation
                                                                  title: text
                                                               subtitle:  @"Destino"]];
            [self.view endEditing: YES];
            
            [self applyZoomToLocation: finalLocation];
            
            [self.mapView removeOverlays: self.mapView.overlays];
            
            CLLocationCoordinate2D sourceLocation = [[self->locationManager location] coordinate];

            MKMapItem *source = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate: sourceLocation]];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark: [[MKPlacemark alloc] initWithCoordinate: finalLocation]];
            
            MKDirectionsRequest *request = [MKDirectionsRequest new];
            
            request.source = source;
            request.destination = destination;
            request.transportType = MKDirectionsTransportTypeAutomobile;
            
            MKDirections *directions = [[MKDirections alloc] initWithRequest: request];
            
            if (!directions.isCalculating) {
                [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (error == nil) {
                        for (MKRoute *route in response.routes) {
                        
                            [self.mapView addOverlay: route.polyline];
                            [self.mapView setVisibleMapRect: route.polyline.boundingMapRect
                                                   animated: YES];
                        }
                        
                    } else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



#pragma mark - Actions

- (IBAction)searchLocation:(id)sender {
    [self setDestinationByText: self.searchText.text];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *latestLocation = [locations firstObject];
    
    currentLocation = [latestLocation coordinate];
    
    [self applyZoomToLocation: currentLocation];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self beginLocationUpdates:manager];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    
    return renderer;
}

#pragma mark - Keyboard Methods
     
- (void) keyBoardWasShow: (NSNotification *) notification{
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration: 0.2 animations:^{
        self.distanceFromBottom.constant = keyboardHeight;
        [self.view layoutIfNeeded];
    }];
}
     
- (void) keyboardWasHide {
    
    [UIView animateWithDuration: 0.2 animations:^{
        self.distanceFromBottom.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void) dissmissKeyboard {
    [self.view endEditing: YES];
}

@end
