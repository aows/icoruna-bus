//
//  BusAnnotation.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 17/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BusAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (id) annotationWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
