//
//  LSAppDelegate.h
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

- (NSDictionary *)readPOIList;

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) NSDictionary *poiDictionary;
@property (weak, readonly) NSArray *allPOIs;
@property (weak, readonly) NSArray *libraryPOIs;
@property (weak, readonly) NSArray *restaurantPOIs;
@property (weak, readonly) NSArray *printerPOIs;

@end
