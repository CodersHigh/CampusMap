//
//  POIItemCell.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 13..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "POIItemCell.h"

@implementation POIItemCell

@synthesize poiLocation=_poiLocation;
@synthesize nameLabel=_nameLabel;

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
                
        [self addSubview:_nameLabel];
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
}
@end
