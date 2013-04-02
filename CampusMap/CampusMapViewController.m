//
//  CampusMapViewController.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "CampusMapViewController.h"
#import "LSAppDelegate.h"
#import "LSLibrary.h"
#import "LSRestaurant.h"
#import "LSPrinter.h"


@implementation CampusMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Campus Map";
        self.tabBarItem.image = [UIImage imageNamed:@"map_view_tab_icon"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = self.poiTypeSegControl;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewDidAppear:(BOOL)animated
{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(37.558, 127.000);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion initialRegion = MKCoordinateRegionMake(center, span);
    
    self.campusMapView.region = initialRegion;
    //[self.campusMapView addAnnotations:[self appDelegate].allPOIs];
    
    self.poiTypeSegControl.selectedSegmentIndex = 0;
    [self.poiTypeSegControl sendActionsForControlEvents: UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [self setCampusMapView:nil];
    [self setPoiTypeSegControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (LSAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *LocationAnnotationIdentifier;
    if ([annotation isKindOfClass:[LSLibrary class]]){
		LocationAnnotationIdentifier = @"LibraryAnnotation";
	} else if ([annotation isKindOfClass:[LSRestaurant class]]) {
		LocationAnnotationIdentifier = @"RestaurantAnnotation";
	} else if ([annotation isKindOfClass:[LSPrinter class]]) {
		LocationAnnotationIdentifier = @"PrinterAnnotation";
	} else {
		return nil;
	}
	
    
	MKAnnotationView *annotationView = [self.campusMapView dequeueReusableAnnotationViewWithIdentifier:LocationAnnotationIdentifier];
	if (!annotationView){
		MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:LocationAnnotationIdentifier];
        customAnnotationView.centerOffset = CGPointMake(0, -10);
		customAnnotationView.canShowCallout = YES;
		customAnnotationView.image = [(LSLocation *)annotation annotationImage];
		
		UIButton *rightDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		customAnnotationView.rightCalloutAccessoryView = rightDetailButton;
		
		return customAnnotationView;
	} else {
		annotationView.annotation = annotation;
	}
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *annotationView;
    float animationDelay = 0.0;
    for (annotationView in views) {
        CGRect endFrame = annotationView.frame;
        
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - 400.0, annotationView.frame.size.width, annotationView.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:animationDelay];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [annotationView setFrame:endFrame];
        [UIView commitAnimations];
        animationDelay = animationDelay + 0.02;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}
- (IBAction)poiUpdate:(id)sender {
    [self.campusMapView removeAnnotations:self.campusMapView.annotations];
    int poiType = self.poiTypeSegControl.selectedSegmentIndex;
    NSArray *selectedPOIs;
    switch (poiType) {
        case 0:
            selectedPOIs = [self appDelegate].libraryPOIs;
            break;
        case 1:
            selectedPOIs = [self appDelegate].restaurantPOIs;
            break;
        case 2:
            selectedPOIs = [self appDelegate].printerPOIs;
            break;
    }
    [self.campusMapView addAnnotations:selectedPOIs];
}

- (IBAction)presentARView:(id)sender {
    _arViewController = [[ARGeoViewController alloc] init];
	_arViewController.debugMode = YES;
	
	_arViewController.delegate = self;
    
	_arViewController.scaleViewsBasedOnDistance = YES;
	_arViewController.minimumScaleFactor = .5;
	
	_arViewController.rotateViewsBasedOnPerspective = YES;
    
    [_arViewController addCoordinates:[self poiARCoordinatesWithType:self.poiTypeSegControl.selectedSegmentIndex]];
    _arViewController.centerLocation = [self appDelegate].currUserLocation;
    
    [_arViewController startListening];
    
    [self presentModalViewController:_arViewController animated:NO];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 20, 30, 20)];
    [closeButton setImage:[UIImage imageNamed:@"map_x_button.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeARView:) forControlEvents:UIControlEventTouchUpInside];
    [_arViewController.ar_overlayView addSubview:closeButton];
}

- (IBAction)closeARView:(id)sender
{
    [_arViewController dismissModalViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:NO];
}

- (NSArray *)poiARCoordinatesWithType:(int)poiType;
{
    NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithCapacity:10];
    NSArray *poiArray;
    switch (poiType) {
        case POI_ALL:
            poiArray = [self appDelegate].allPOIs;
            break;
        case POI_LIBRARY:
            poiArray = [self appDelegate].libraryPOIs;
            break;
        case POI_RESTAURANT:
            poiArray = [self appDelegate].restaurantPOIs;
            break;
        case POI_PRINTER:
            poiArray = [self appDelegate].printerPOIs;
            break;
    }
    
    for (LSLocation *poiLocation in poiArray) {
        CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:poiLocation.latitude longitude:poiLocation.longitude];
        ARGeoCoordinate *tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation];
        tempCoordinate.title = poiLocation.title;
        tempCoordinate.poiLocation = poiLocation;
        
        [tempLocationArray addObject:tempCoordinate];
    }
    
    return (NSArray *)tempLocationArray;
}


#define BOX_WIDTH 150
#define BOX_HEIGHT 100

- (UIView *)viewForCoordinate:(ARCoordinate *)coordinate {
    CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	UIView *tempView = [[UIView alloc] initWithFrame:theFrame];
	
	//tempView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.3];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
	titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = coordinate.title;
	[titleLabel sizeToFit];
	
	titleLabel.frame = CGRectMake(BOX_WIDTH / 2.0 - titleLabel.frame.size.width / 2.0 - 4.0, 0, titleLabel.frame.size.width + 8.0, titleLabel.frame.size.height + 8.0);
	
	UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectZero];
	pointView.image = [(ARGeoCoordinate *)coordinate poiLocation].annotationImage;
	pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - pointView.image.size.height / 2.0), pointView.image.size.width, pointView.image.size.height);
    
	[tempView addSubview:titleLabel];
	[tempView addSubview:pointView];
	
	return tempView;
}
@end
