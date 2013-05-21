//
//  StopAnnotation.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 27/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface StopAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *direction;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (id) annotationWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)tit subtitle:(NSString*)subt;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)tit subtitle:(NSString*)subt;

@end
