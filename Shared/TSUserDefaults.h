//
//  TSUserDefaults.h
//  Meeper
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const TSPreferenceHideOverlay;
extern NSString* const TSPreferenceOverlayState;
extern NSString* const TSPreferenceVolumeState;

@interface TSUserDefaults : NSObject

+ (NSUserDefaults *) sharedUserDefaults;

@end