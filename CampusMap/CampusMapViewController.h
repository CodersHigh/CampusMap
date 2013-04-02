//
//  CampusMapViewController.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CampusMapViewController : UIViewController

- (IBAction)poiUpdate:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *poiTypeSegControl;
@property (strong, nonatomic) IBOutlet MKMapView *campusMapView;

@end
