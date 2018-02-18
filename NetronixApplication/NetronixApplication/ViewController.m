//
//  ViewController.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 16/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ViewController.h"

#import <EventSource.h>
#import "ILMeasurement.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSURL *serverURL = [NSURL URLWithString:@"https://jsdemo.envdev.io/sse"];
	EventSource *source = [EventSource eventSourceWithURL:serverURL];
	
	[source onMessage:^(Event *event) {
		if ([event.data length] > 0) {
			NSError *readingError;
			NSArray *eventsArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:[event.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error: &readingError];
			
			if (readingError) {
				NSLog(@"Reading EventSource JSON error: %@", readingError);
				return;
			}
			
			// @INFO: we can to check it with [NSNull null], but with [NSArray class] easier
			if (eventsArray && [eventsArray isKindOfClass:[NSArray class]] && (eventsArray.count > 0)) {
				for (NSDictionary *eventDictionary in eventsArray) {
					if (eventDictionary && [eventDictionary isKindOfClass:[NSDictionary class]]) {
						NSArray *measurementsArray  = (NSArray *) eventDictionary[@"measurements"];
						
						if (measurementsArray && [measurementsArray isKindOfClass:[NSArray class]]) {
							ILMeasurement *measurement = [self convertTimeSerieToMeasurementObjectsFromEventDictionary:eventDictionary];
							
							
							measurement = nil;
							event = nil;
						} else {
							[self convertTimeSerieToMeasurementObjectsFromEventDictionary:eventDictionary];
							NSLog(@"ERROR. No \"measurements\" array in timeserie %@", eventDictionary);
						}
					} else {
						NSLog(@"ERROR. Wrong format of event: %@", eventDictionary);
					}
				}
			}
		}
		
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Private messages



-(ILMeasurement *) convertTimeSerieToMeasurementObjectsFromEventDictionary: (NSDictionary *) eventDictionary {
	NSArray *measurementsArray = (NSArray *) eventDictionary[@"measurements"];
	if (measurementsArray.count > 0) {
		for (NSArray *singleMeasurementArray in measurementsArray) {
			if ([singleMeasurementArray isKindOfClass:[NSArray class]]) {
				ILMeasurement *measurementObject = [[ILMeasurement alloc] init];
				
				NSString *measurementTimeSerieIdString = eventDictionary[@"_id"];
				if (measurementTimeSerieIdString &&
					[measurementTimeSerieIdString isKindOfClass:[NSString class]] &&
					(measurementTimeSerieIdString.length > 0)) {
					measurementObject.timeSerieIdString = measurementTimeSerieIdString;
				}
				
				NSString *measurementNameString = eventDictionary[@"name"];
				if (measurementNameString &&
					[measurementNameString isKindOfClass:[NSString class]] &&
					(measurementNameString.length > 0)) {
					measurementObject.nameString = measurementNameString;
				}
				
				NSString *unitString = eventDictionary[@"unit"];
				if (unitString &&
					[unitString isKindOfClass:[NSString class]] &&
					(unitString.length > 0)) {
					measurementObject.unitString = unitString;
				}
				
				if ((singleMeasurementArray.count >= 1) && singleMeasurementArray[0]) {
					// expect epoch date
					NSNumber *epochDateNumber = singleMeasurementArray[0];
					if (epochDateNumber &&
						[epochDateNumber isKindOfClass:[NSNumber class]]) {
						measurementObject.date = [NSDate dateWithTimeIntervalSince1970:[epochDateNumber integerValue]];
					}
				}
				
				if ((singleMeasurementArray.count >= 2) && singleMeasurementArray[1]) {
					id valueObject = singleMeasurementArray[1];
					if (valueObject && [valueObject isKindOfClass:[NSNumber class]]) {
						// single number value
						measurementObject.valueString = [((NSNumber *) valueObject) stringValue];
					} else if (valueObject && [valueObject isKindOfClass:[NSString class]]) {
						measurementObject.valueString = (NSString *) valueObject;
					} else if (valueObject && [valueObject isKindOfClass:[NSArray class]]) {
						NSArray *valueArray = (NSArray *) valueObject;
						
						if (valueArray.count == 2) {
							measurementObject.valueArray = valueArray;
						} else {
							measurementObject.valueArray = valueArray;
							NSLog(@"ERROR. Unexpected array from measurement: %@", measurementObject);
							return measurementObject;
						}
					}
				}
				
				NSLog(@"%@", measurementObject);
				return measurementObject;
			}
		}
	} else {
		ILMeasurement *measurementObject = [[ILMeasurement alloc] init];
		
		NSString *measurementTimeSerieIdString = eventDictionary[@"_id"];
		if (measurementTimeSerieIdString &&
			[measurementTimeSerieIdString isKindOfClass:[NSString class]] &&
			(measurementTimeSerieIdString.length > 0)) {
			measurementObject.timeSerieIdString = measurementTimeSerieIdString;
		}
		
		NSString *measurementNameString = eventDictionary[@"name"];
		if (measurementNameString &&
			[measurementNameString isKindOfClass:[NSString class]] &&
			(measurementNameString.length > 0)) {
			measurementObject.nameString = measurementNameString;
		}
		
		NSString *unitString = eventDictionary[@"unit"];
		if (unitString &&
			[unitString isKindOfClass:[NSString class]] &&
			(unitString.length > 0)) {
			measurementObject.unitString = unitString;
		}
		
		NSLog(@"ERROR. Empty measurement: %@", measurementObject);
		return measurementObject;
	}
	
	return nil;
}

@end
