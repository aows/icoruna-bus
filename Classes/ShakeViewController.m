//
//  ShakeViewController.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 16/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "ShakeViewController.h"

@implementation ShakeViewController

- (void)viewWillAppear:(BOOL)animated {
	[shakeView becomeFirstResponder];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[shakeView resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// shake
	shakeView.controller = self;
	
}

-(void)shakeDetected {
	NSLog(@"Shake detection not implemented");
}

@end
