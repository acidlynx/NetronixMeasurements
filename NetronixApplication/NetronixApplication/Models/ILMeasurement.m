//
//  Measurement.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 18/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ILMeasurement.h"

@implementation ILMeasurement

-(NSString *) description {
	NSString *debugDescriptionString = [NSString stringWithFormat:@"ILMeasurement:\nid=%@\nname=%@\nunit=%@",
										self.timeSerieIdString,
										self.nameString,
										self.unitString];
	
	return debugDescriptionString;
}

@end
