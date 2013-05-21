//
//  iBusAppDelegate.m
//  iBus
//
//  Created by Adrián Otero Vila on 20/11/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iBusAppDelegate.h"
#import "RootViewController.h"
#import "Stops.h"
#import "FlurryAPI.h"
#ifdef __APPLE__
	#include "TargetConditionals.h"
#endif


@implementation iBusAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle
void uncaughtExceptionHandler (NSException *exception) {
    [FlurryAPI logError:@"UNCAUGHT" message:@"CRASH!" exception:exception];
	NSLog(@"CRASH! Exception: %@", exception);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

	// init flurry
#if (!TARGET_IPHONE_SIMULATOR)
	[FlurryAPI startSessionWithLocationServices:@"KV4HCQY8XJTL2FTKHYB1"];
#endif
	
	// load stops from plist
	[Stops initStops];
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

