//
//  AboutViewController.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 17/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

- (IBAction) dismiss {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void) viewDidLoad {
	aboutTextView.font = [UIFont fontWithName:@"Helvetica" size:13];
}

- (void) dealloc {
	[aboutTextView release];
	[super dealloc];
}

@end
