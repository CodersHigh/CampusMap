//
//  CampusPOIViewController.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampusPOIViewController : UITableViewController

@property BOOL libraryExpanded;
@property BOOL restaurantExpanded;
@property BOOL printerExpanded;

@property (readonly) int numOfLibrary;
@property (readonly) int numOfRestaurant;
@property (readonly) int numOfPrinter;


@end
