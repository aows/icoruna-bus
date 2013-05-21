//
//  AboutViewController.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 17/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AboutViewController : UIViewController {
	UITextView *aboutTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *aboutTextView;

-(IBAction) dismiss;

@end
