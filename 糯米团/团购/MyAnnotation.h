//
//  MyAnnotation.h
//  糯米团
//
//  Created by Sunny on 12/11/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *shopName;

@end
