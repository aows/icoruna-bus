//
//  RootViewController.m
//  iBus
//
//  Created by Adrián Otero Vila on 20/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "LineViewController.h"
#import "OptionsViewController.h"
#import "Stops.h";

@implementation RootViewController

@synthesize busesLines, openPrefsButton;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Create a final modal view controller
	UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[modalViewButton addTarget:self action:@selector(openPrefs) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = modalBarButtonItem;
	[modalViewButton release];
	[modalBarButtonItem release];

	// read lines from the plist file
	NSString *path = [[NSBundle mainBundle] pathForResource: @"lines" ofType:@"plist"];
	busesLines = [[NSMutableArray alloc] initWithContentsOfFile: path];

}

- (IBAction) openPrefs {
	OptionsViewController *optionsViewController = [[OptionsViewController alloc] init];
	[self.navigationController pushViewController:optionsViewController animated:YES];
	[optionsViewController release];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [busesLines count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	
	// Configure the cell.
	NSDictionary *currentLine = [busesLines objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", [currentLine objectForKey:@"name"]];
	
	NSString *lineDesc = [NSString stringWithFormat:@"%@", [currentLine objectForKey:@"desc"]];
	if (lineDesc != nil && ![lineDesc isEqualToString:@"(null)"]) {
		cell.detailTextLabel.text = lineDesc;
	}	
	
	
	// line icon
	cell.indentationLevel = 1;
	cell.indentationWidth = 35;
	
	CGRect frame; frame.origin.x = 5; frame.origin.y = 5; frame.size.height = 32; frame.size.width = 32;
	
	UIImageView *imgLabel = [[UIImageView alloc] initWithFrame:frame];
	imgLabel.tag = 1000;
	[cell.contentView addSubview:imgLabel];
	[imgLabel release];
	
	UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:1000];
	imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"line-%@.png", [currentLine objectForKey:@"id"]]];
	

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	LineViewController *lineViewController = [[LineViewController alloc] init];
	lineViewController.lineId = [[busesLines objectAtIndex:indexPath.row] objectForKey:@"id"];
	lineViewController.lineName = [[busesLines objectAtIndex:indexPath.row] objectForKey:@"name"];
	lineViewController.idaName = [[busesLines objectAtIndex:indexPath.row] objectForKey:@"idaName"];
	lineViewController.vueltaName = [[busesLines objectAtIndex:indexPath.row] objectForKey:@"vueltaName"];	
	lineViewController.lineWebCode = [[busesLines objectAtIndex:indexPath.row] objectForKey:@"webCode"];
	[self.navigationController pushViewController:lineViewController animated:YES];
	[lineViewController release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

