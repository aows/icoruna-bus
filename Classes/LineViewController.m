//
//  LineViewController.m
//  iBus
//
//  Created by Adrián Otero Vila on 20/11/10.
//  Copyright 2010 adrianotero.es. All rights reserved.
//


#import "LineViewController.h"
#import "ASIFormDataRequest.h"
#import "ShadowView.h"
#import "ParseTranviasWeb.h"
#import "TFHppleElement.h"
#import "UserAgents.h"
#import "ShowMapViewController.h"
#import "Stop.h"
#import "Stops.h"
#import "FlurryAPI.h"
#import "DSActivityView.h"

@implementation LineViewController

@synthesize asiRequest;
@synthesize lineId, lineName, linesTable;
@synthesize lineWebCode, idaName, vueltaName;


-(void)showError:(NSString *)title message:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													 message:message
													delegate:self 
										   cancelButtonTitle:@"Ok"
										   otherButtonTitles:nil];
	[alert show];
	[alert release];
}
	
-(void)loadLineInfo {
	
	// show the loading icon
	[self setLoadingToolbar];
	
	// show the hud
	[DSBezelActivityView newActivityViewForView:self.view withLabel:@"cargando buses..."];
	
	[FlurryAPI logEvent:@"GET_LINE" withParameters:[NSDictionary dictionaryWithObject:lineId forKey:@"line"]];
	
	// connection to coruna.es
	NSString* url = [NSString stringWithFormat: @"http://www.coruna.es/guiaLocal/situacion_bus.jsp?current=au&accion=2&idlinea=%@", self.lineWebCode];
	//NSString* url = @"http://rlopez.es/buses.html";
	asiRequest = [[ASIHTTPRequest alloc] initWithURL: [NSURL URLWithString:url]];
	//[asiRequest addRequestHeader:@"Host" value:@"www.coruna.es"];
	[asiRequest addRequestHeader:@"User-Agent" value:[UserAgents randomUserAgent]];
	[asiRequest addRequestHeader:@"Referer" value:@"http://www.coruna.es/guiaLocal/paradas_bus.jsp"];
	NSLog(@"%@", [asiRequest requestHeaders]);
	[asiRequest setTimeOutSeconds:30];
	[asiRequest setDelegate:self];
	[asiRequest startAsynchronous];

}

-(void)requestFinished:(ASIHTTPRequest *) request {

	[self setDefaultToolbar];
	[DSBezelActivityView removeViewAnimated:YES];
	
	if (asiRequest != nil) {
		
		// reset the buses arrays
		[busesI release];
		busesI = nil;
		[busesV release];
		busesV = nil;
		busesI = [[NSMutableArray alloc] init];
		busesV = [[NSMutableArray alloc] init];
		busesT = [ParseTranviasWeb parse:[request responseData] line:self.lineId];
		
		if ([busesT count] == 0) {
			NSLog(@"La web de tranvías no responde");
			[self showError:@"Error" message:@"La web de Tranvías no responde"];
			
		} else if ([busesT count] == 1 && [[busesT objectAtIndex:0] isKindOfClass:[TFHppleElement class]]) {
			NSLog(@"No se han encontrado buses");
			[busesT removeObjectAtIndex:0];
			[self showError:@"Error" message:@"No se han encontrado buses"];
			
		} else {
			NSLog(@"datos actualizados");
			
			// update ida and vuelta
			for (Bus *tmpBus in busesT) {
				if ([tmpBus.direction isEqualToString:@"I"]) {
					[busesI addObject:tmpBus];
				} else if ([tmpBus.direction isEqualToString:@"V"]) {
					[busesV addObject:tmpBus];
				}
			}			

		}
		
		[self reloadTable];
		[asiRequest release];
		asiRequest = nil;
		
	}
	
}

-(void)requestFailed:(ASIHTTPRequest *) request {

	[self setDefaultToolbar];
	[DSBezelActivityView removeViewAnimated:YES];
	
	if (![request isCancelled]) {
		NSLog(@"%@", [request responseStatusCode]);
		[self showError:@"Error" message:@"La conexión ha fallado"];		
	}
	if (asiRequest != nil) {
		[asiRequest release];
		asiRequest = nil;	
	}
}


// table population
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [NSString stringWithFormat:@"Hacia %@", self.vueltaName];
		case 1:
			return [NSString stringWithFormat:@"Hacia %@", self.idaName];
	}
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0) {
		return stopsI.count;
	} else if (section == 1) {
		return stopsV.count;
	} else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// save the current stop to paint its name in the cell
	Stop *currentStop = nil;
	if (indexPath.section == 0) {
		currentStop = [stopsI objectAtIndex:(int) indexPath.row];
	} else {
		currentStop = [stopsV objectAtIndex:(int) indexPath.row];
	}
	
	// this stop has any bus?
	NSArray *busesForStop = [self busesForStop:indexPath.row direction:indexPath.section == 0 ? @"I" : @"V"];	
	
	// the cell identifier
	NSString *cellIdentifier = nil;
	if (busesForStop.count > 0) {
		cellIdentifier = @"stopWithBusCell";
	} else {
		cellIdentifier = @"stopCell";
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 215, cell.textLabel.frame.size.height);
	cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
	cell.textLabel.text = currentStop.name;
	
	// cell cleanup
	// remove the subviews to avoid overlapping of buses views
	for (UIView *subView in [cell.contentView subviews]) {
		if (subView.tag == 100 || subView.tag == 101) {
			[subView removeFromSuperview];
		}
	}
	
	cell.indentationLevel = 1;
	cell.indentationWidth = 27;
	
	
	int numOfRows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
	if (indexPath.row == 0) {
		UIImageView *symbolView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"first_stop_symbol.png"]];
		symbolView.frame = CGRectMake(5, 8, 25, 35);
		symbolView.tag = 101;
		[cell.contentView addSubview:symbolView];
		[symbolView release];
	} else if (indexPath.row == numOfRows-1) {	
		UIImageView *symbolView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"last_stop_symbol.png"]];
		symbolView.frame = CGRectMake(5, -3, 25, 36);
		symbolView.tag = 101;
		[cell.contentView addSubview:symbolView];
		[symbolView release];
	} else {
		UIImageView *symbolView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal_stop_symbol.png"]];
		symbolView.frame = CGRectMake(5, -3, 25, 43);
		symbolView.tag = 101;
		[cell.contentView addSubview:symbolView];
		[symbolView release];

	}
	
	
	// paint the bus
	if (busesForStop.count > 0) {
		// create the bus view, the icon and the label
		UIImageView *busView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bus_icon_back.png"]];
		busView.frame = CGRectMake(243, 0, 80, 40);
		busView.tag = 100;
		UILabel *busNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10, 35, 20)];
		busNumberLabel.backgroundColor = [UIColor clearColor];
		busNumberLabel.text = [[busesForStop objectAtIndex:0] number];
		busNumberLabel.font = [UIFont fontWithName:@"Marker Felt" size:16];
		busNumberLabel.textColor = [UIColor whiteColor];
		[busView addSubview:busNumberLabel];
		[busNumberLabel release];
		[cell.contentView addSubview:busView];
		[busView release];
	}
	
	return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

-(NSMutableArray *)busesForStop:(int)stopIndex direction:(NSString*)direction {
	Stop *stop = nil;
	NSArray *busesToIterate = nil;
	if ([direction isEqualToString:@"I"]) {
		stop = [stopsI objectAtIndex:stopIndex];
		busesToIterate = busesI;
	} else {
		stop = [stopsV objectAtIndex:stopIndex];
		busesToIterate = busesV;
	}	
	
	NSMutableArray *toRet = [[[NSMutableArray alloc] init] autorelease];
	for (Bus *bus in busesToIterate) {
		if ([bus.nextStop isEqualToString:stop.name]) {
			[toRet addObject:bus];
		}
	}
	return toRet;
}


-(void) cancelCurrentRequest {
	if (asiRequest != nil) {
		[asiRequest cancel];
		[asiRequest release];
		asiRequest = nil;
	}	
}

- (IBAction)updateInfo {
	[self cancelCurrentRequest];
	[self loadLineInfo];
}

//shaking
-(void)shakeDetected {
	[self updateInfo];
}

- (IBAction) showMap {
	ShowMapViewController *showMapViewController = [[ShowMapViewController alloc] initWithLine:lineId busesI:busesI busesV:busesV];
	[self presentModalViewController:showMapViewController animated:YES];
	[showMapViewController release];	
}

- (void) setDefaultToolbar {
	showMapButton.enabled = YES;
	[infoToolbar setItems:[NSArray arrayWithObjects:refreshButton,fixedSpace,showMapButton,nil]];	
}
- (void) setLoadingToolbar {
	showMapButton.enabled = NO;	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [activityIndicator release];
	[infoToolbar setItems:[NSArray arrayWithObjects:activityItem,fixedSpace,showMapButton,nil]];
    [activityItem release];	
}

- (void) reloadTable {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[linesTable reloadData];
	[UIView commitAnimations];	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self reloadTable];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self cancelCurrentRequest];
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = lineName;
	
	// load stops
	stopsI = [Stops stopsForLine:lineId direction:@"I"];
	stopsV = [Stops stopsForLine:lineId direction:@"V"];
	
	// delegate and datasource
	[linesTable setDelegate:self];
	[linesTable setDataSource:self];
	
	[self loadLineInfo];
	
}

- (void) dealloc {
	[asiRequest release];
	
	[lineId release];
	[lineName release];
	[linesTable release];
	[nibLoadedCell release];
	
	[infoToolbar release];
	[refreshButton release];
	[fixedSpace release];
	[showMapButton release];
	
	[busesT release];
	[busesI release];
	[busesV release];
	[stopsI release];
	[stopsV release];	
	[lineWebCode release];
	[idaName release];
	[vueltaName release];
    [super dealloc];
}

@end
