//
//  ParseTranviasWeb.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 20/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParseTranviasWeb : NSObject {

}

+ (NSMutableArray*)parse:(NSData *)data line:(NSString *)line;

@end
