//
//  ShowMapViewController.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 24/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ShowMapViewController.h"
#import "Bus.h"
#import "BusAnnotation.h"
#import "FlurryAPI.h"
#import "Stops.h"
#import "Stop.h"
#import "StopAnnotation.h"

@implementation ShowMapViewController

@synthesize line, busesI, busesV;

- (id) initWithLine:(NSString *)lineId busesI:(NSArray *)busesIda busesV:(NSArray *)busesVuelta {
	if ( !(self = [super init]) )
		return nil;
	
	self.line = lineId;
	self.busesI = busesIda;
	self.busesV = busesVuelta;
	
	return self;
}

- (void) dealloc {
	[line release];
	[busesI release];
	[busesV release];
	[mapView release];
	[super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[FlurryAPI logEvent:@"VIEW_MAP" withParameters:[NSDictionary dictionaryWithObject:line forKey:@"line"]];
	
	// setup the map
	MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
	region.center = CLLocationCoordinate2DMake(43.35589,-8.408489);
	region.span.longitudeDelta = 0.05f;
	region.span.latitudeDelta = 0.05;
	[mapView setRegion:region animated:YES];
	
	// show annotations for stops
	[mapView addAnnotations:[self annotationsForStopsForDirection:@"I"]];
	[mapView addAnnotations:[self annotationsForStopsForDirection:@"V"]];
	
	// show annotations for buses
	[mapView addAnnotations:[self annotationsForBuses:busesI]];
	[mapView addAnnotations:[self annotationsForBuses:busesV]];
	
}

-(NSMutableArray *)annotationsForStopsForDirection:(NSString*) dir {
	NSMutableArray *annotations = [[[NSMutableArray alloc] init] autorelease];
	for (Stop* stop in [Stops stopsForLine:line direction:dir]) {
		CLLocationCoordinate2D coordinate = { [stop.latitude floatValue], [stop.longitude floatValue] };
		NSString *direction = [dir isEqualToString:@"I"] ? @"sentido IDA" : @"sentido VUELTA";
		StopAnnotation *annotation = [StopAnnotation annotationWithCoordinate:coordinate title:stop.name subtitle:direction direction:stop.direction];
		[annotations addObject:annotation];
	}
	return annotations;
}

-(NSMutableArray *)annotationsForBuses:(NSArray*)buses {
	NSMutableArray *annotations = [[[NSMutableArray alloc] init] autorelease];
	if (buses != nil && buses.count > 0) {
		for (Bus *bus in buses) {
			CLLocationCoordinate2D coordinate = { [bus.latitude floatValue], [bus.longitude floatValue] };
			BusAnnotation *annotation = [BusAnnotation annotationWithCoordinate:coordinate];
			annotation.title = [NSString stringWithFormat:@"Bus %@", bus.number];
			annotation.subtitle = [NSString stringWithFormat:@"Hacia %@", bus.nextStop];
			[annotations addObject:annotation];
		}
	}
	return annotations;
}



- (IBAction) closeMap {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
	
    static NSString *annotationViewID = nil;

	if ([annotation isKindOfClass:[BusAnnotation class]]) {
		annotationViewID = @"annotationViewID";
	} else {
		annotationViewID = @"stopAnnotationViewID";
	}
	
    MKAnnotationView *annotationView = (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
	
    if (annotationView == nil)
    {
		if ([annotation isKindOfClass:[BusAnnotation class]]) {
			annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID] autorelease];
			annotationView.image = [UIImage imageNamed:@"pin_bus.png"];			
			[annotationView setCenterOffset:CGPointMake(10, -32)];
			[annotationView.superview bringSubviewToFront:annotationView];
		} else if ([annotation isKindOfClass:[StopAnnotation class]]) {
			annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID] autorelease];		
			if ([[annotation direction] isEqualToString:@"I"]) {
				[annotationView setPinColor:MKPinAnnotationColorGreen];
			} else {
				[annotationView setPinColor:MKPinAnnotationColorPurple];
			}
		}
    }

    annotationView.annotation = annotation;
	annotationView.canShowCallout = YES;
	
    return annotationView;
}

@end
