//
//  Bus.h
//  iBus
//
//  Created by Adrián Otero Vila on 14/12/10.
//  Copyright 2010 adrianotero.es. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Bus : NSObject {
	NSString* number;
	NSString* nextStop;
	NSString* prevStop;
	NSNumber* longitude;
	NSNumber* latitude;
	NSString* direction;
}

@property (nonatomic, retain) NSString* number;
@property (nonatomic, retain) NSString* nextStop;
@property (nonatomic, retain) NSString* prevStop;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSString* direction;

@end
