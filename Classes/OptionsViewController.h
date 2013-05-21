//
//  OptionsViewController.h
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 16/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface OptionsViewController : UIViewController<UITableViewDelegate, MFMailComposeViewControllerDelegate> {
	
	IBOutlet UITableView *tableView;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
