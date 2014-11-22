//
//  TSTodaySettings.h
//  Meeper
//
//  Created by Tristan Seifert on 11/20/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ITSwitch;
@interface TSTodaySettings : NSViewController {
	IBOutlet NSTextField *_aboutText;
	
	IBOutlet ITSwitch *_hideOverlaySwitch;
}

@end
