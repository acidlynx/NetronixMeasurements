//
//  Measurement.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 18/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ILMeasurement.h"
#import "ILSanitizeHelpers.h"

@implementation ILMeasurement
#pragma mark - initializers
-(instancetype) init {
	self = [super init];
	if (self) {
		self.timeSerieIdString = nil;
		self.nameString = nil;
		self.date = nil;
		self.unitString = nil;
		self.valueString = nil;
		self.valueArray = nil;
	}
	
	return self;
}

-(nonnull instancetype) initWithEventDictionary: (null_unspecified NSDictionary *) eventDictionary; {
	self = [super init];
	if (self) {
		self.timeSerieIdString = [ILSanitizeHelpers sanitizedStringFromValue:eventDictionary[@"_id"]];
		self.nameString = [ILSanitizeHelpers sanitizedStringFromValue:eventDictionary[@"name"]];
		self.unitString = [ILSanitizeHelpers sanitizedStringFromValue:eventDictionary[@"unit"]];
		self.date = nil;
		self.valueString = nil;
		self.valueArray = nil;
	}
	
	return self;
}

#pragma mark - inherit messages
-(NSString *) description {
	NSString *debugDescriptionString = [NSString stringWithFormat:@"\nILMeasurement:\nid=%@\ndate=%@\nname=%@\nunit=%@\nvalue=%@\narray=%@",
										self.timeSerieIdString,
										self.date,
										self.nameString,
										self.unitString,
										self.valueString,
										self.valueArray];
	
	return debugDescriptionString;
}

@end
