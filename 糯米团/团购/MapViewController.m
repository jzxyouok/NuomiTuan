//
//  MapViewController.m
//  糯米团
//
//  Created by Sunny on 12/11/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {
    CLLocationDegrees longitude;
    CLLocationDegrees latitude;
}

@property (strong, nonatomic) CLLocation *targetLocation;
@property (strong, nonatomic) MyAnnotation *annotation;

- (void)gecodeToDisplayTargetLocation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _shopAddress;
    //定位请求
    _locationManager = [CLLocationManager new];
    [_locationManager requestWhenInUseAuthorization];
    //经纬转换
    longitude = (CLLocationDegrees)[_longtitudeStr floatValue];
    latitude = (CLLocationDegrees)[_latitudeStr floatValue];
    _targetLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    _map.delegate = self;
    
    [self gecodeToDisplayTargetLocation];
}

- (void)gecodeToDisplayTargetLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_targetLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //传过来1个数据，所以就一个
        CLPlacemark *placemark = placemarks[0];
        //显示地图缩放比例
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 500, 500);
        [_map setRegion:viewRegion animated:YES];
        //设置标注
        _annotation = [MyAnnotation new];
        _annotation.shopName = _shopName;
        _annotation.address = _shopAddress;
        _annotation.coordinate = placemark.location.coordinate;
        [_map addAnnotation:_annotation];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapDelegate implements
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //使用可重用对象节省内存
    MKPinAnnotationView *annotaionView = (MKPinAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
    if (!annotaionView) {
        annotaionView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    //设置大头针颜色
    annotaionView.pinColor = MKPinAnnotationColorPurple;
    //大头针动态插入
    annotaionView.animatesDrop = YES;
    //显示附加信息在大头针处
    annotaionView.canShowCallout = YES;
    
    return annotaionView;
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
