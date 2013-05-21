//
//  Stops.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 21/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "Stop.h"
#import "Stops.h"
#import "FlurryAPI.h"

@interface StopsHidden : NSObject
{}
+ (NSArray *)stopsForLine:(NSString *)line direction:(NSString *)direction bundleInfo:(NSArray *)bundleInfo;

@end

@implementation StopsHidden

+ (NSArray *)stopsForLine:(NSString *)line direction:(NSString *)direction bundleInfo:(NSArray *)bundleInfo {
	NSMutableArray *lineStops = [[[NSMutableArray alloc] init] autorelease];
	for (NSDictionary *dicLine in bundleInfo) {
		if ([[dicLine objectForKey:@"line"] isEqualToString:line]
			&& [[dicLine objectForKey:@"direction"] isEqualToString:direction]) {
			
			for (NSDictionary *dicStop in [dicLine objectForKey:@"stops"]) {
				Stop *stop = [[Stop alloc] init];
				stop.line = line;
				stop.direction = direction;
				stop.order = [dicStop objectForKey:@"order"];
				stop.code = [dicStop objectForKey:@"code"];
				stop.name = [dicStop objectForKey:@"name"];
				stop.latitude = [dicStop objectForKey:@"latitude"];
				stop.longitude = [dicStop objectForKey:@"longitude"];
				
				[lineStops addObject:stop];
				[stop release];
			}
		}
	}
	return lineStops;
}

@end



static NSMutableDictionary *stops;

@implementation Stops

+(void) initStops {
	NSString *path = [[NSBundle mainBundle] pathForResource: @"stops" ofType:@"plist"];
	NSArray *stopsFromPlist = [[NSMutableArray alloc] initWithContentsOfFile: path];
	
	stops = [[NSMutableDictionary alloc] init];
	NSArray *lines = [NSArray arrayWithObjects:@"1", @"1A", @"2", @"2A", @"3", @"3A", @"4", @"5", @"6", @"6A", @"7", @"11", @"12", @"12A", @"14", @"17", @"20", @"21", @"22", @"23", @"23A", @"24", @"E", @"B", nil];
	for (NSString *line in lines) {
		[stops setObject:[StopsHidden stopsForLine:line direction:@"I" bundleInfo:stopsFromPlist] forKey:[NSString stringWithFormat:@"%@I", line]];
		[stops setObject:[StopsHidden stopsForLine:line direction:@"V" bundleInfo:stopsFromPlist] forKey:[NSString stringWithFormat:@"%@V", line]];
	}
	[stopsFromPlist release];
}

+(NSArray *)stopsForLine:(NSString *)line direction:(NSString *)direction {
	return [stops objectForKey:[NSString stringWithFormat:@"%@%@", line, direction]];
}

+(NSString *)directionForStops:(NSString *)lastStop nextStop:(NSString *)nextStop line:(NSString *)line {

	NSArray *tmpStops = [Stops stopsForLine:line direction:@"I"];
	if ([tmpStops count] > 0) {
		Stop *firstStop = [tmpStops objectAtIndex:0];
		if ([firstStop.name isEqualToString:lastStop] && [firstStop.name isEqualToString:nextStop]) {
			return @"I";
		}
		for (int i = 0; i < [tmpStops count]-1; i++) {
			Stop *tmpStop1 = [tmpStops objectAtIndex:i];
			Stop *tmpStop2 = [tmpStops objectAtIndex:i+1];			
			if ([lastStop isEqualToString:tmpStop1.name] && [nextStop isEqualToString:tmpStop2.name]) {
				return @"I";
			}
		}
	}
	
	tmpStops = [Stops stopsForLine:line direction:@"V"];
	if ([tmpStops count] > 0) {	
		Stop *firstStop = [tmpStops objectAtIndex:0];
		if ([firstStop.name isEqualToString:lastStop] && [firstStop.name isEqualToString:nextStop]) {
			return @"V";
		}
		for (int i = 0; i < [tmpStops count]-1; i++) {
			Stop *tmpStop1 = [tmpStops objectAtIndex:i];
			Stop *tmpStop2 = [tmpStops objectAtIndex:i+1];			
			if ([lastStop isEqualToString:tmpStop1.name] && [nextStop isEqualToString:tmpStop2.name]) {
				return @"V";
			}
		}	
	}
	
	
	NSString *errorMessage = [NSString stringWithFormat:@"Direction not found for line %@: %@ -> %@", line, lastStop, nextStop];
	NSLog(errorMessage);
#if (!TARGET_IPHONE_SIMULATOR)	
	[FlurryAPI logError:@"DIR_NOT_FOUND" message:errorMessage error:nil];
#endif
	return @"U";
	
}

@end
