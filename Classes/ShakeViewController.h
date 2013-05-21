//
//  ShakeViewController.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 16/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShakeView.h"


@interface ShakeViewController : UIViewController {

	ShakeView *shakeView;
	
}

@property (nonatomic, retain) IBOutlet ShakeView *shakeView;

- (void) shakeDetected;

@end
