//
//  LSLocation.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LSLocation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (copy) NSString *title;
@property (copy) NSString *subtitle;
@property (copy) NSString *location;
@property (strong, readonly) NSString *addressOfLocation;

@property CLLocationDegrees longitude;
@property CLLocationDegrees latitude;

@property (strong, readonly) UIImage *annotationImage;

@end
