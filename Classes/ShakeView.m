//
//  ShakeView.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 15/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "ShakeView.h"
#import "ShakeViewController.h"


@implementation ShakeView

@synthesize controller;

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
		[controller shakeDetected];
    }
	
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

@end
