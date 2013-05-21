//
//  LineViewController.h
//  iBus
//
//  Created by Adrián Otero Vila on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Bus.h"
#import "ASIHTTPRequest.h"
#import "ShakeViewController.h"


@interface LineViewController : ShakeViewController<UITableViewDelegate,UITableViewDataSource> {

	
	ASIHTTPRequest *asiRequest;
	
	NSString *lineId;
	NSString *lineName;
	UITableView *linesTable;
	UITableViewCell *nibLoadedCell;
	
	UIToolbar *infoToolbar;
	UIBarButtonItem *refreshButton;
	UIBarButtonItem *fixedSpace;
	UIBarButtonItem *showMapButton;
	
	// arrays to store the buses
	NSMutableArray *busesT;
	NSMutableArray *busesI;
	NSMutableArray *busesV;
	
	// info about the line
	NSArray *stopsI;
	NSArray *stopsV;
	NSString *lineWebCode;
	NSString *idaName;
	NSString *vueltaName;
	
}

@property (nonatomic, retain) ASIHTTPRequest *asiRequest;

@property (nonatomic, retain) NSString *lineId;
@property (nonatomic, retain) NSString *lineName;
@property (nonatomic, retain) IBOutlet UITableView *linesTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

@property (nonatomic, retain) IBOutlet UIToolbar *infoToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *fixedSpace;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *showMapButton;

@property (nonatomic, retain) Bus *bus;
@property (nonatomic, readonly) NSMutableArray *busesT;
@property (nonatomic, readonly) NSMutableArray *busesI;
@property (nonatomic, readonly) NSMutableArray *busesV;
@property (nonatomic, readonly) NSArray *stopsI;
@property (nonatomic, readonly) NSArray *stopsV;

@property (nonatomic, retain) NSString *lineWebCode;
@property (nonatomic, retain) NSString *idaName;
@property (nonatomic, retain) NSString *vueltaName;

- (IBAction) updateInfo;
- (IBAction) showMap;
- (void) setDefaultToolbar;
- (void) setLoadingToolbar;
- (void) reloadTable;
-(NSMutableArray *)busesForStop:(int)stopIndex direction:(NSString*)direction;

@end
