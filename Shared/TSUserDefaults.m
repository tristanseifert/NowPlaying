//
//  TSUserDefaults.m
//  Meeper
//
//	Abstracts away the logic needed for shared user defaults between any apps in
//	a suite, and exposes a simple class method for getting a user defaults obj
//	shared between all apps.
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSUserDefaults.h"

// When YES, the overlays can be hidden by clicking anywhere except buttons.
NSString* const TSPreferenceHideOverlay = @"TSPreferenceHideOverlay";
// When YES, the previous button always goes to the previous track, rather than
// replicating the iTunes behaviour.
NSString* const TSPreferencePreviousBehaviour = @"TSPreferencePreviousBehaviour";

NSString* const TSPreferenceOverlayState = @"TSPreferenceOverlayState";
NSString* const TSPreferenceVolumeState = @"TSPreferenceVolumeState";

static NSUserDefaults *sharedInstance = nil;

@implementation TSUserDefaults

+ (NSUserDefaults *) sharedUserDefaults {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.tseifert.meeper"];
		
		// try to register defaults
		NSString *path = [[NSBundle bundleForClass:TSUserDefaults.class] pathForResource:@"DefaultSettings" ofType:@"plist"];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
		
		if(dict) {
			[sharedInstance registerDefaults:dict];
		}
	});
	
	return sharedInstance;
}

@end