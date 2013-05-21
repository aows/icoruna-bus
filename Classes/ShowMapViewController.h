//
//  ShowMapViewController.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 24/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShowMapViewController : UIViewController<MKMapViewDelegate> {
	NSString *line;
	NSArray *busesI;
	NSArray *busesV;	
	MKMapView *mapView;
}

@property (nonatomic, retain) NSString *line;
@property (nonatomic, retain) NSArray *busesI;
@property (nonatomic, retain) NSArray *busesV;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (id)initWithLine:(NSString *)lineId busesI:(NSArray *)busesIda busesV:(NSArray *)busesVuelta;

- (IBAction) closeMap;
- (NSMutableArray *)annotationsForStopsForDirection:(NSString*)dir;
- (NSMutableArray *)annotationsForBuses:(NSArray*)buses;

@end
