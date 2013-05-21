//
//  OptionsViewController.m
//  iCoruna Bus
//
//  Created by Adrián Otero Vila on 16/01/11.
//  Copyright 2011 Adrián Otero. All rights reserved.
//

#import "OptionsViewController.h"
#import "AboutViewController.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FlurryAPI.h"

@implementation OptionsViewController

@synthesize tableView;

-(void)viewDidLoad {
	self.title = @"Preferencias";
	
	[FlurryAPI logEvent:@"VIEW_OPTIONS"];	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	CGRect headerViewFrame = CGRectMake(0, 0, 320, 245);
	CGRect logoViewFrame = CGRectMake(82, 15, 150, 150);
	CGRect headerTextFrame = CGRectMake(20, 145, 280, 95);
	NSString *logoName = @"logo_large.png";	
	
	UIView *headerView = [[[UIView alloc] initWithFrame:headerViewFrame] autorelease];
	UIImageView *logo = [[UIImageView alloc] initWithFrame:logoViewFrame];
	logo.image = [UIImage imageNamed:logoName];
	[headerView addSubview:logo];
	[logo release];
	
	UILabel *headerText = [[UILabel alloc] initWithFrame:headerTextFrame];
	headerText.backgroundColor = [UIColor clearColor];
	headerText.textColor = [UIColor darkGrayColor];
	headerText.font = [UIFont fontWithName:@"Helvetica" size:22];
	headerText.numberOfLines = 0;
	headerText.textAlignment = UITextAlignmentCenter;
	headerText.text = [NSString stringWithFormat:@"iCoruna Bus %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	[headerView addSubview:headerText];
	[headerText release];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 225;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleGray;	
	
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Acerca de iCoruna Bus";
			break;
		case 1:
			cell.textLabel.text = @"Envía sugerencia o problema";
			break;
		case 2:
			cell.textLabel.text = @"Recomienda iCoruna Bus";
			break;
		case 3:
			cell.textLabel.text = @"Dejar reseña en AppStore";
			break;
		default:
			break;
	}
	//cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		AboutViewController *controller = [[AboutViewController alloc] init];
		[self presentModalViewController:controller animated:YES];		
		[controller release];
		
	} else if (indexPath.row == 1) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject: [NSString stringWithFormat:@"Sugerencia / problema con iCoruna Bus %@", 
								 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ]];
		[controller setToRecipients:[NSArray arrayWithObject:@"info@icoruna.es"]];
		[controller setMessageBody:@"" isHTML:NO]; 
		[self presentModalViewController:controller animated:YES];
		[controller release];		
	} else if (indexPath.row == 2) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject: @"Prueba iCoruna Bus para tu iPhone"];
		[controller setMessageBody:@"¡Hola!<br/><br/>Me he descargado esta aplicación gratuita para seguir los buses urbanos de A Coruña en tiempo real que quizá te pueda interesar: <a href='http://itunes.apple.com/es/app/icoruna-bus/id411757773?mt=8'>iCoruna Bus</a>" isHTML:YES]; 
		[self presentModalViewController:controller animated:YES];
		[controller release];		
	} else if (indexPath.row == 3) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=411757773&mt=8"]];
	}
	// deselect option
	[tableView reloadData];	
}
		 
- (void)mailComposeController:(MFMailComposeViewController*)controller  
					didFinishWithResult:(MFMailComposeResult)result 
					error:(NSError*)error; 
		{
			if (result == MFMailComposeResultSent) {
				NSLog(@"It's away!");
			}
			[self dismissModalViewControllerAnimated:YES];
		}
		 

-(void) dealloc {
	[tableView release];
	[super dealloc];
}


@end
