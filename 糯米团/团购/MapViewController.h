//
//  MapViewController.h
//  糯米团
//
//  Created by Sunny on 12/11/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSString *longtitudeStr;
@property (strong, nonatomic) NSString *latitudeStr;
@property (strong, nonatomic) NSString *shopName;
@property (strong, nonatomic) NSString *shopAddress;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *map;

- (IBAction)back:(UIBarButtonItem *)sender;

@end
