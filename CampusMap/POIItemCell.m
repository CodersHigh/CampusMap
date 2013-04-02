//
//  POIItemCell.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 13..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "POIItemCell.h"

@implementation POIItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *backgroundImage = [UIImage imageNamed:@"subcell.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 180, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textColor = [UIColor lightGrayColor];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 20, 80, 12)];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.font = [UIFont boldSystemFontOfSize:11];
        _distanceLabel.textColor = [UIColor lightGrayColor];
                
        [self addSubview:_nameLabel];
        [self addSubview:_distanceLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPoiLocation:(LSLocation *)poiLocation
{
    _poiLocation = poiLocation;
    
    _nameLabel.text = _poiLocation.title;
    _distanceLabel.text = _poiLocation.distanceString;
}
@end
