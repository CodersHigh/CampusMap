//
//  CampusPOIViewController.m
//  CampusMap
//
//  Created by 윤 성관 on 11. 9. 8..
//  Copyright (c) 2011년 LingoStar. All rights reserved.
//

#import "CampusPOIViewController.h"
#import "LSAppDelegate.h"
#import "LSLibrary.h"
#import "LSRestaurant.h"
#import "LSPrinter.h"
#import "POITypeCell.h"
#import "POIItemCell.h"

#define TypeCellHeight 52
#define ItemCellHeight 47

@interface CampusPOIViewController (){
    int _titleRow[3];
}
- (LSAppDelegate *)appDelegate;
- (void)refreshTitleRow;
@end

@implementation CampusPOIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Campus POI";
        self.tabBarItem.image = [UIImage imageNamed:@"poi_view_tab_icon"];
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

    _libraryExpanded = _restaurantExpanded = _printerExpanded = NO;
    [self refreshTitleRow];
	[self addObserver:self forKeyPath:@"libraryExpanded" options:0 context:nil];
	[self addObserver:self forKeyPath:@"restaurantExpanded" options:0 context:nil];
	[self addObserver:self forKeyPath:@"printerExpanded" options:0 context:nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"libraryExpanded"] | [keyPath isEqualToString:@"restaurantExpanded"] | [keyPath isEqualToString:@"printerExpanded"]){
		[self refreshTitleRow];
		[self.tableView reloadData];
	}
}

- (LSAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)refreshTitleRow
{
	_titleRow[0] = 0;
	if (_libraryExpanded) {
		_titleRow[1] = self.numOfLibrary + 1;
    } else {
		_titleRow[1] = _titleRow[0] + 1;
    }
	if (_restaurantExpanded){
		_titleRow[2] = _titleRow[1] + self.numOfRestaurant + 1;
    } else {
		_titleRow[2] = _titleRow[1] + 1;
    }
}

- (int)numOfLibrary
{
	return [[self appDelegate].libraryPOIs count];
}

- (int)numOfRestaurant
{
	return [[self appDelegate].restaurantPOIs count];
}

- (int)numOfPrinter
{
	return [[self appDelegate].printerPOIs count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 3;
	if (_libraryExpanded) rowCount += self.numOfLibrary;
	if (_restaurantExpanded) rowCount += self.numOfRestaurant;
	if (_printerExpanded) rowCount += self.numOfPrinter;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TypeCellIdentifier = @"TypeCell";
	static NSString *ItemCellIdentifier = @"ItemCell";
    
    NSString *identifier;
	if (indexPath.row == _titleRow[POI_LIBRARY] ||
        indexPath.row == _titleRow[POI_RESTAURANT] ||
        indexPath.row == _titleRow[POI_PRINTER]) {
		identifier = TypeCellIdentifier;
	} else {
		identifier = ItemCellIdentifier;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        Class cellClass;
        if ([identifier isEqualToString:@"TypeCell"]){
            cellClass = [POITypeCell class];
        } else {
            cellClass = [POIItemCell class];
        }
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    int rowNum = indexPath.row;
    if (rowNum == _titleRow[POI_LIBRARY]){
		[(POITypeCell *)cell setPoiType:POI_LIBRARY];
        [(POITypeCell *)cell setNumberOfItems:self.numOfLibrary];
	} else if ( rowNum == _titleRow[POI_RESTAURANT] ) {
		[(POITypeCell *)cell setPoiType:POI_RESTAURANT];
        [(POITypeCell *)cell setNumberOfItems:self.numOfRestaurant];
	} else if (rowNum == _titleRow[POI_PRINTER]) {
		[(POITypeCell *)cell setPoiType:POI_PRINTER];
        [(POITypeCell *)cell setNumberOfItems:self.numOfPrinter];
	} else if ( _titleRow[POI_LIBRARY] < rowNum && rowNum < _titleRow[POI_RESTAURANT]) {
		LSLibrary *currLibrary = [[self appDelegate].libraryPOIs  objectAtIndex:(rowNum-1)];
        [(POIItemCell *)cell setPoiLocation:currLibrary];
	}  else if ( _titleRow[POI_RESTAURANT] < rowNum && rowNum < _titleRow[POI_PRINTER]) {
		int index = rowNum - _titleRow[1];
		LSRestaurant *currRestaurant = [[self appDelegate].restaurantPOIs objectAtIndex:index-1];
		[(POIItemCell *)cell setPoiLocation:currRestaurant];
	} else if (rowNum > _titleRow [POI_PRINTER]) {
		int index = rowNum - _titleRow[POI_PRINTER];
		LSPrinter *currPrinter = [[self appDelegate].printerPOIs objectAtIndex:index-1];
		[(POIItemCell *)cell setPoiLocation:currPrinter];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int rowNum = indexPath.row;
	CGFloat height;
    if (rowNum == _titleRow[POI_LIBRARY] ||
        rowNum == _titleRow[POI_RESTAURANT] ||
        rowNum == _titleRow[POI_PRINTER])
		height = TypeCellHeight;
	else
		height = ItemCellHeight;
    
	return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSLocation *selectedPOI;
	int rowNum = indexPath.row;
    if (rowNum == _titleRow[0]){
		self.libraryExpanded = !self.libraryExpanded;
		return;
	} else if ( _titleRow[0] < rowNum && rowNum < _titleRow[1]) {
		selectedPOI = [[self appDelegate].libraryPOIs  objectAtIndex:(rowNum-1)];
	} else if ( rowNum == _titleRow[1] ) {
		self.restaurantExpanded = !self.restaurantExpanded;
		return;
	} else if ( _titleRow[1] < rowNum && rowNum < _titleRow[2]) {
		int index = rowNum - _titleRow[1];
		selectedPOI = [[self appDelegate].restaurantPOIs objectAtIndex:index-1];
	} else if (rowNum == _titleRow[2]) {
		self.printerExpanded = !self.printerExpanded;
		return;
	} else if (rowNum > _titleRow [2]) {
		int index = rowNum - _titleRow[2];
		selectedPOI = [[self appDelegate].printerPOIs objectAtIndex:index-1];
	}
}

@end
