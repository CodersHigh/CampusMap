//
//  LSLibrary.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "LSLibrary.h"

@implementation LSLibrary

@synthesize libraryName = _libraryName;
@synthesize annotationImage=_annotationImage;

- (UIImage *)annotationImage
{
	if (_annotationImage == nil){
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"library_annotation" ofType:@"png"];
		_annotationImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
	}
	return _annotationImage;
}

- (NSString *)title
{
    return self.libraryName;
}

@end
