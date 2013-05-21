//
//  RootViewController.h
//  iBus
//
//  Created by Adrián Otero Vila on 20/11/10.
//  Copyright adrianotero.es 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
	NSMutableArray *busesLines;
	UIBarButtonItem *openPrefsButton;
}

@property (nonatomic, retain) NSMutableArray *busesLines;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *openPrefsButton;

- (IBAction) openPrefs;

@end
