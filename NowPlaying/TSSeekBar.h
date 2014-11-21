//
//  TSSeekBar.h
//  Meeper
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TSiTunesController;

IB_DESIGNABLE
@interface TSSeekBar : NSView {
	BOOL _isDragging;
	
	CGFloat _currentTimeToDraw;
	
	IBOutlet TSiTunesController *_iTunes;
}

@property (nonatomic, readwrite) IBInspectable CGFloat endTime;
@property (nonatomic, readwrite) IBInspectable CGFloat currentTime;

@end
