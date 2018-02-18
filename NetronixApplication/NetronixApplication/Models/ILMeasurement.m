//
//  Measurement.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 18/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ILMeasurement.h"

@implementation ILMeasurement

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
