//
//  BusAnnotation.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 17/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "BusAnnotation.h"


@implementation BusAnnotation

@synthesize coordinate, title, subtitle;

+(id) annotationWithCoordinate:(CLLocationCoordinate2D)coordinate {
	return [[[BusAnnotation alloc] initWithCoordinate:coordinate] autorelease];
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord {
	self = [super init];
	if (nil != self) {
		self.coordinate = coord;
	}
	return self;
}

@end
