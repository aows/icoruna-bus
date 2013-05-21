//
//  StopAnnotation.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 27/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "StopAnnotation.h"
#import "BusAnnotation.h"


@implementation StopAnnotation

@synthesize coordinate, title, subtitle, direction;

+(id) annotationWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)tit subtitle:(NSString*)subt direction:(NSString*)dir {
	return [[[StopAnnotation alloc] initWithCoordinate:coordinate title:tit subtitle:subt direction:dir] autorelease];
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString*)tit subtitle:(NSString*)subt direction:(NSString*)dir {
	self = [super init];
	if (nil != self) {
		self.coordinate = coord;
		self.title = tit;
		self.subtitle = subt;
		self.direction = dir;
	}
	return self;
}

@end