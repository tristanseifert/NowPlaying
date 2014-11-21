//
//  NSFloatToDateTransformer.m
//  Meeper
//
//	Transforms an UNIX timestamp to a string in the MM:SS format.
//
//  Created by Tristan Seifert on 11/21/14.
//  Copyright (c) 2014 Tristan Seifert. All rights reserved.
//

#import "TSFloatToTimeIntervalTransformer.h"

@implementation TSFloatToTimeIntervalTransformer

/**
 * We transform to an NSDate.
 */
+ (Class) transformedValueClass {
	return [NSString class];
}

/**
 * Transforms a float, interpreted as an UNIX timestamp, to a date.
 */
- (id)transformedValue:(id) value {
	NSNumber *num = value;
	NSUInteger timestamp = num.floatValue;
	NSUInteger secs = timestamp % 60;
	NSUInteger mins = timestamp / 60;
	
	return [NSString stringWithFormat:@"%lu:%02lu", mins, secs];
}

@end
