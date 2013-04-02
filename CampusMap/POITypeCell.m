//
//  POITypeCell.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 13..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "POITypeCell.h"

@implementation POITypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"cell_selectedWithArrow.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 62, 37)];
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 150, 27)];
        _numberOfPOILabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 20, 100, 14)];
        
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.font = [UIFont boldSystemFontOfSize:24];
        _typeLabel.textColor = [UIColor darkGrayColor];
        
        _numberOfPOILabel.backgroundColor = [UIColor clearColor];
        _numberOfPOILabel.font = [UIFont systemFontOfSize:12];
        _numberOfPOILabel.textColor = [UIColor colorWithHue:0.2 saturation:0.7 brightness:0.7 alpha:1.0];
        
        [self addSubview:_typeLabel];
        [self addSubview:_iconImageView];
        [self addSubview:_numberOfPOILabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPoiType:(int)poiType
{
    _poiType = poiType;
    NSString *typeString;
    UIImage *typeIconImage;
    switch (poiType) {
        case POI_LIBRARY:
            typeString = @"Library";
            typeIconImage = [UIImage imageNamed:@"icon_library"];
            break;
        case POI_RESTAURANT:
            typeString = @"Restaurant";
            typeIconImage = [UIImage imageNamed:@"icon_restaurant"];
            break;
        case POI_PRINTER:
            typeString = @"Printer";
            typeIconImage = [UIImage imageNamed:@"icon_printer"];
            break;
    }
    _typeLabel.text = typeString;
    _iconImageView.image = typeIconImage;
}

- (void)setNumberOfItems:(int)numberOfItems
{
    _numberOfPOILabel.text = [NSString stringWithFormat:@"%d Items", numberOfItems];
}
@end
