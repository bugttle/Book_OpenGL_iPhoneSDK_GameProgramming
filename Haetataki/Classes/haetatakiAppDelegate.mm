//
//  haetatakiAppDelegate.mm
//  Haetataki
//
//  Created by UQTimes on 12/09/01.
//  Copyright (c) 2012年 UQTimes. All rights reserved.
//

#import "haetatakiAppDelegate.h"
#import "EAGLView.h"

@implementation haetatakiAppDelegate

@synthesize window;
@synthesize glView;

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	[glView startAnimation];
}

- (void) applicationWillResignActive:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) dealloc
{
	[window release];
	[glView release];
	
	[super dealloc];
}

@end
