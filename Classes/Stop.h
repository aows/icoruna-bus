//
//  Stop.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 21/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stop : NSObject {
	NSString *order;
	NSString *line;
	NSString *direction;
	NSString *code;
	NSString *name;
	NSNumber *latitude;
	NSNumber *longitude;
}

@property (nonatomic, retain) NSString *order;
@property (nonatomic, retain) NSString *line;
@property (nonatomic, retain) NSString *direction;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end
