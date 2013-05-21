//
//  MenuViewController.m
//  iBus
//
//  Created by Adrián Otero Vila on 20/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"


@implementation MenuViewController

-(void)viewDidLoad {
	self.title = @"+info";	
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]isDirectory:NO]]];
}

@end
