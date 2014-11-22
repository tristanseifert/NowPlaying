//
//  TSTodaySettings.m
//  Meeper
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "ITSwitch.h"
#import "TSUserDefaults.h"

#import "TSTodaySettings.h"

@interface TSTodaySettings ()

@end

@implementation TSTodaySettings

/**
 * View loaded: complete some initialisation
 */
- (void) viewDidLoad {
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Settings", nil);
	
	// Update version text (version, build)
	NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
	NSString *build = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
	NSString *str = [NSString stringWithFormat:_aboutText.stringValue, version, build];
	_aboutText.stringValue = str;
}

/**
 * Saves settings when the view controller is about to go off-screen.
 */
- (void) viewWillDisappear {
	NSUserDefaults *d = [TSUserDefaults sharedUserDefaults];
	
	// if overlay hiding is off, make sure they're always displayed
	[d setBool:_hideOverlaySwitch.isOn forKey:TSPreferenceHideOverlay];
	if(!_hideOverlaySwitch.isOn) {
		[d setBool:YES forKey:TSPreferenceOverlayState];
	}
	
//	NSLog(@"Settings: %@", d.dictionaryRepresentation);
	
	// save
	[d synchronize];
}

/**
 * Restores settings from user defaults as the view is about to appear.
 */
- (void) viewWillAppear {
	NSUserDefaults *d = [TSUserDefaults sharedUserDefaults];
	_hideOverlaySwitch.on = [d boolForKey:TSPreferenceHideOverlay];
}

@end
