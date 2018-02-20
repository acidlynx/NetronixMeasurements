//
//  ILSanitizeHelpers.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 19/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ILSanitizeHelpers.h"

@implementation ILSanitizeHelpers

+(NSString *)sanitizedStringFromValue:(id)rawValue {
	if (rawValue) {
		if ([rawValue isKindOfClass:[NSString class]] && (((NSString *)rawValue).length > 0)) {
			return rawValue;
		} else if ([rawValue isKindOfClass:[NSNumber class]]) {
			return [((NSNumber *) rawValue) stringValue];
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

+(null_unspecified NSDate *) sanitizedDateFromValue: (null_unspecified id) rawValue {
	if (rawValue &&
		[rawValue isKindOfClass:[NSNumber class]]) {
		return [NSDate dateWithTimeIntervalSince1970:[((NSNumber *)rawValue) integerValue]];
	} else {
		return nil;
	}
}

+(null_unspecified NSArray *) sanitizedArrayFromValue: (null_unspecified id) rawValue {
	if (rawValue && [rawValue isKindOfClass:[NSArray class]]) {
		return (NSArray *)rawValue;
	} else {
		return nil;
	}
}

@end
