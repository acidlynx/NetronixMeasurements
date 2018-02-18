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
							[self convertTimeSerieToMeasurementObjectsFromEventDictionary:eventDictionary];
						} else {
							[self convertTimeSerieToMeasurementObjectsFromEventDictionary:eventDictionary];
							NSLog(@"Error: no \"measurements\" array in timeserie %@", eventDictionary);
						}
					} else {
						NSLog(@"eventDictionary: %@", eventDictionary);
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
-(void) convertTimeSerieToMeasurementObjectsFromEventDictionary: (NSDictionary *) eventDictionary {
	NSArray *measurementsArray  = (NSArray *) eventDictionary[@"measurements"];
	if (measurementsArray.count > 0) {
//		for (NSDictionary *measurementDictionary in measurementsArray) {
//			
//		}
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
		
		measurementObject.valueString = @"";
		
		NSLog(@"empty measurement: %@", measurementObject);
	}
}

@end
