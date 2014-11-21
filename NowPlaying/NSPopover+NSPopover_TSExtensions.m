//
//  NSPopover+NSPopover_TSExtensions.m
//  Meeper
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "NSPopover+NSPopover_TSExtensions.h"

@implementation NSPopover (NSPopover_TSExtensions)

/**
 * Opens the popover, with the arrow pointing to the sender. This will cause the
 * popover to appear centered horizontally below the sender, if possible.
 */
- (IBAction) openPopoverFromSender:(id) sender {
	NSView *view = (NSView *) sender;
	[self showRelativeToRect:view.bounds ofView:view preferredEdge:NSMaxYEdge];
}

@end
