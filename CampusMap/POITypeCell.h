//
//  POITypeCell.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 13..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POITypeCell : UITableViewCell

@property int poiType;
@property int numberOfItems;

@property (strong , readonly) UIImageView *iconImageView;
@property (strong , readonly) UILabel *typeLabel;
@property (strong , readonly) UILabel *numberOfPOILabel;

@end
