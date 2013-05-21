//
//  Stops.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 21/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stops : NSObject {

}

+(void) initStops;
+(NSArray *)stopsForLine:(NSString *)line direction:(NSString *)direction;
+(NSString *)directionForStops:(NSString *)lastStop nextStop:(NSString *)nextStop line:(NSString *)line;

@end
