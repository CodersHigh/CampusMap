//
//  LSAppDelegate.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "LSAppDelegate.h"
#import "CampusMapViewController.h"
#import "CampusPOIViewController.h"
#import "LSLibrary.h"
#import "LSRestaurant.h"
#import "LSPrinter.h"
#import <CoreLocation/CoreLocation.h>

@interface LSAppDelegate (){
    NSDictionary *_poiDictionary;
    CLLocationManager *_locationManager;
}

@end

@implementation LSAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    CampusMapViewController *mapViewController = [[CampusMapViewController alloc] initWithNibName:@"CampusMapViewController" bundle:nil];
    UINavigationController *mapNavController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    CampusPOIViewController *poiViewController = [[CampusPOIViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *poiNavController = [[UINavigationController alloc] initWithRootViewController:poiViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:mapNavController, poiNavController, nil];
    
    self.window.rootViewController = tabBarController;
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
	_locationManager.distanceFilter = kCLDistanceFilterNone;
	[_locationManager startUpdatingLocation];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (NSArray *)allPOIs
{
	NSMutableArray *pois = [[NSMutableArray alloc] initWithArray:self.libraryPOIs];
	[pois addObjectsFromArray:self.restaurantPOIs];
	[pois addObjectsFromArray:self.printerPOIs];
	
	return (NSArray *)pois;
}

- (NSArray *)libraryPOIs
{
	return [self.poiDictionary valueForKey:@"LibraryPOI"];
}

- (NSArray *)restaurantPOIs
{
	return [self.poiDictionary valueForKey:@"RestaurantPOI"];
}

- (NSArray *)printerPOIs
{
	return [self.poiDictionary valueForKey:@"PrinterPOI"];
}

- (NSDictionary *)poiDictionary
{
	if (_poiDictionary == nil) {
		_poiDictionary = [[NSDictionary alloc] initWithDictionary:[self readPOIList]];
	}
    return _poiDictionary;
}

- (NSDictionary *)readPOIList
{
	NSMutableArray *printerArray = [[NSMutableArray alloc] initWithCapacity:10];
	NSMutableArray *restaurantArray = [[NSMutableArray alloc] initWithCapacity:10];
	NSMutableArray *libraryArray = [[NSMutableArray alloc] initWithCapacity:10];
	
	NSString *poiFilePath = [[NSBundle mainBundle] pathForResource:@"POI" ofType:@"plist"];
	NSArray *poiFileArray = [NSArray arrayWithContentsOfFile:poiFilePath];
	
	NSDictionary *aPOI;
	NSMutableArray *targetArray;
	Class poiClass;
	for (aPOI in poiFileArray) {
		int poiType = [[aPOI valueForKey:@"type"] intValue];
		switch (poiType) {
			case POI_LIBRARY:
				poiClass = [LSLibrary class];
				targetArray = libraryArray;
				break;
			case POI_RESTAURANT:
				poiClass = [LSRestaurant class];
				targetArray = restaurantArray;
				break;
			case POI_PRINTER:
				poiClass = [LSPrinter class];
				targetArray = printerArray;
				break;
		}
		LSLocation *newLocation = [[poiClass alloc] init];
		CLLocationDegrees latitude = [[aPOI valueForKey:@"latitude"] doubleValue];
		CLLocationDegrees longitude = [[aPOI valueForKey:@"longitude"] doubleValue];
		newLocation.latitude = latitude;
		newLocation.longitude = longitude;
        
		NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[aPOI allKeys]];
		NSArray *excludeKeys = [NSArray arrayWithObjects:@"type", @"latitude",@"longitude", nil];
		[allKeys removeObjectsInArray:excludeKeys];
		NSString *key;
		for (key in allKeys) {
			[newLocation setValue:[aPOI valueForKey:key] forKey:key];
		}
		[targetArray addObject:newLocation];
	}
	
	NSDictionary *returnDictionary = [NSDictionary dictionaryWithObjectsAndKeys:libraryArray, @"LibraryPOI",restaurantArray, @"RestaurantPOI", printerArray, @"PrinterPOI", nil];
	return returnDictionary;
}

#pragma mark - CLLocation Manager Delegate
- (void)locationManager:(CLLocationManager *)locationManager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;
{
	_currUserLocation = newLocation;
}
@end
