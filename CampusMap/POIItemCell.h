//
//  POIItemCell.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 13..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSLibrary.h"
#import "LSRestaurant.h"
#import "LSPrinter.h"

@interface POIItemCell : UITableViewCell

@property (strong) LSLocation *poiLocation;
@property (strong, readonly) UILabel *nameLabel;
@property (strong, readonly) UILabel *distanceLabel;
@end
