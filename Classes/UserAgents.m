//
//  UserAgents.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 21/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "UserAgents.h"
#include <stdlib.h>

@implementation UserAgents

+(NSString *) randomUserAgent {
	NSArray *userAgents = [[[NSArray alloc] initWithObjects:@"Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3",
						   @"Mozilla/5.0 (Windows; U; Windows NT 6.1; en; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)",
						   @"Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)",
						   @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; es-ES; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13",
						   @"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; Win64; x64; Trident/4.0)",
						   nil] autorelease];	
	return [userAgents objectAtIndex:arc4random()%[userAgents count]];
}

@end
