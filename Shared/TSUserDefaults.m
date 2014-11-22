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

NSString* const TSPreferenceHideOverlay = @"TSPreferenceHideOverlay";
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