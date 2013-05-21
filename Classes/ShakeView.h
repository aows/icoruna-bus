//
//  ShakeView.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 15/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShakeViewController;


@interface ShakeView : UIView {

	ShakeViewController *controller;
	
}

@property (nonatomic, retain) ShakeViewController *controller;

@end
