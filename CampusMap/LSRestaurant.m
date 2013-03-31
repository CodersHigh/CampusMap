//
//  LSRestaurant.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "LSRestaurant.h"

@implementation LSRestaurant

@synthesize restaurantName = _restaurantName;
@synthesize store = _store;
@synthesize annotationImage=_annotationImage;

- (UIImage *)annotationImage
{
	if (_annotationImage == nil){
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"restaurant_annotation" ofType:@"png"];
		_annotationImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
	}
	return _annotationImage;
}

- (NSString *)title
{
    return self.restaurantName;
}

@end
