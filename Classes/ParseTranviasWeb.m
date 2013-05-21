//
//  ParseTranviasWeb.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 20/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "ParseTranviasWeb.h"
#import "TFHpple.h"
#import "Bus.h"
#import "Stops.h"
#include <math.h>

@implementation ParseTranviasWeb

+ (NSMutableArray *)parse:(NSData *)data line:(NSString *)line {
	NSMutableArray *buses = [[NSMutableArray alloc] init];
	
	TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
	NSArray *noBuses = [doc search:@"//dl[@class='itemOscuro']/dt"];
	if ([noBuses count] == 1) {
		if ([[[noBuses objectAtIndex:0] content] isEqualToString:@"No hay autobuses recorriendo la línea en este momento."]) {
			return noBuses;
		}
	}
	
	NSArray *busNumber = [doc search:@"/html/body/div/div[3]/div/div[3]/form/div/div/dl[@class='itemOscuro']/dt/i"];
	NSArray *stops = [doc search:@"/html/body/div/div[3]/div/div[3]/form/div/div/dl[@class='itemOscuro']/dd/em"];
	NSArray *geo = [doc search:@"//li[@class='geoLocalizacion']/a"];
	[doc release];

	for (int i = 0; i < [busNumber count]; i++) {
		Bus *bus = [[Bus alloc] init];
		bus.number = [[busNumber objectAtIndex:i] content];
		bus.prevStop = [[stops objectAtIndex:i*3+1] content];
		bus.nextStop = [[stops objectAtIndex:i*3+2] content];
		bus.direction = [Stops directionForStops:bus.prevStop nextStop:bus.nextStop line:line];
		
		
		NSString *geoInfo = [[geo objectAtIndex:i] objectForKey:@"href"];

		NSRange before = [geoInfo rangeOfString:@"(\""];
		NSRange after = [geoInfo rangeOfString:@"\" ,"];
		NSRange myRange = NSMakeRange((before.location + (int)2), (after.location - before.location - (int)2));
		NSString *latitudeString = [geoInfo substringWithRange:myRange];

		before = [geoInfo rangeOfString:@"\" ,\""];
		after = [geoInfo rangeOfString:@"\","];
		myRange = NSMakeRange((before.location + (int)4), (after.location - before.location - (int)4));
		NSString *longitudeString = [geoInfo substringWithRange:myRange];
		
		
		// converting to latitude & longitude
		int zone = 29;
		double easting = [latitudeString doubleValue] - 130.0;
		double northing = [longitudeString doubleValue] - 200.0;
		double latitude = 0.0;
		double longitude = 0.0;

		double b = 6356752.314;
		double a = 6378137;
		double e = 0.081819191;
		double e1sq = 0.006739497;
		double k0 = 0.9996;
		
		double arc = northing / k0;
		double mu = arc	/ (a * (1 - pow(e, 2) / 4.0 - 3 * pow(e, 4) / 64.0 - 5 * pow(e, 6) / 256.0));		
		double ei = (1 - pow((1 - e * e), (1 / 2.0))) / (1 + pow((1 - e * e), (1 / 2.0)));
		double ca = 3 * ei / 2 - 27 * pow(ei, 3) / 32.0;
		double cb = 21 * pow(ei, 2) / 16 - 55 * pow(ei, 4) / 32;
		double cc = 151 * pow(ei, 3) / 96;
		double cd = 1097 * pow(ei, 4) / 512;
		double phi1 = mu + ca * sin(2 * mu) + cb * sin(4 * mu) + cc * sin(6 * mu) + cd * sin(8 * mu);
		double n0 = a / pow((1 - pow((e * sin(phi1)), 2)), (1 / 2.0));
		double r0 = a * (1 - e * e) / pow((1 - pow((e * sin(phi1)), 2)), (3 / 2.0));
		double fact1 = n0 * tan(phi1) / r0;
		double _a1 = 500000 - easting;
		double dd0 = _a1 / (n0 * k0);
		double fact2 = dd0 * dd0 / 2;
		double t0 = pow(tan(phi1), 2);
		double Q0 = e1sq * pow(cos(phi1), 2);
		double fact3 = (5 + 3 * t0 + 10 * Q0 - 4 * Q0 * Q0 - 9 * e1sq) * pow(dd0, 4) / 24;
		double fact4 = (61 + 90 * t0 + 298 * Q0 + 45 * t0 * t0 - 252 * e1sq - 3 * Q0 * Q0) * pow(dd0, 6) / 720;
		double lof1 = _a1 / (n0 * k0);
		double lof2 = (1 + 2 * t0 + Q0) * pow(dd0, 3) / 6.0;
		double lof3 = (5 - 2 * Q0 + 28 * t0 - 3 * pow(Q0, 2) + 8 * e1sq + 24 * pow(t0, 2)) * pow(dd0, 5) / 120;
		double _a2 = (lof1 - lof2 + lof3) / cos(phi1);
		double _a3 = _a2 * 180 / M_PI;
		
		latitude = 180 * (phi1 - fact1 * (fact2 + fact3 + fact4)) / M_PI;
		double zoneCM = 0.0;
		if (zone > 0) {
			zoneCM = 6 * zone - 183.0;
		} else {
			zoneCM = 3.0;
		}
		longitude = zoneCM - _a3;
		
		bus.latitude = [NSNumber numberWithDouble: latitude];
		bus.longitude = [NSNumber numberWithDouble: longitude];
		
		
		[buses addObject:bus];
		[bus release];
	}
	
	return buses;
}

@end
