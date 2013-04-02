//
//  CampusMapViewController.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ARGeoViewController.h"
#import "ARGeoCoordinate.h"

@interface CampusMapViewController : UIViewController

- (IBAction)poiUpdate:(id)sender;
- (IBAction)presentARView:(id)sender;
- (IBAction)closeARView:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *poiTypeSegControl;
@property (strong, nonatomic) IBOutlet MKMapView *campusMapView;
@property (strong, readonly) ARGeoViewController *arViewController;
@end
