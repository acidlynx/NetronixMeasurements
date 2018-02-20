//
//  ViewController.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 16/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ViewController.h"

#import <EventSource.h>
#import "ILSanitizeHelpers.h"
#import "ILMeasurement.h"

static NSString *errorDomainString = @"test.domain.error";
static NSString *cellIdentifierString = @"measurementTableViewCellIdentifier";

typedef void (^ILConverTimeSerieBlock)(ILMeasurement *measurementObject, NSError *errorObject);

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_measurementsCommonArray = [[NSMutableArray alloc] init];

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
						[self convertTimeSerieFromEventDictionary:eventDictionary withBlock:^(ILMeasurement *measurementObject, NSError *errorObject) {
							if (errorObject) {
								NSLog(@"ERROR: %@", errorObject.localizedDescription);
							}
							
							[_measurementsCommonArray addObject:measurementObject];
							
//							NSIndexPath *newRowIndexPath = [NSIndexPath indexPathForRow:_measurementsCommonArray.count-1 inSection:0];
//							dispatch_sync(dispatch_get_main_queue(), ^{
//								[_measurementsTableView beginUpdates];
//								[_measurementsTableView insertRowsAtIndexPaths:@[newRowIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//								[_measurementsTableView endUpdates];
//								[_measurementsTableView reloadData];
//							});
							
							dispatch_async(dispatch_get_main_queue(), ^{
								[_measurementsTableView reloadData];
							});
							
							NSLog(@"measurement: %@", measurementObject);
						}];
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
-(void) convertTimeSerieFromEventDictionary: (NSDictionary *) eventDictionary withBlock: (ILConverTimeSerieBlock) returnBlock {
	NSArray *measurementsArray = (NSArray *) eventDictionary[@"measurements"];
	if (measurementsArray &&
		[measurementsArray isKindOfClass:[NSArray class]] &&
		(measurementsArray.count > 0)) {
		for (NSArray *singleMeasurementArray in measurementsArray) {
			if ([singleMeasurementArray isKindOfClass:[NSArray class]]) {
				ILMeasurement *measurementObject = [[ILMeasurement alloc] initWithEventDictionary:eventDictionary];
				
				if ((singleMeasurementArray.count >= 1) && singleMeasurementArray[0]) {
					// expect epoch date
					measurementObject.date = [ILSanitizeHelpers sanitizedDateFromValue:singleMeasurementArray[0]];
				}
				
				if ((singleMeasurementArray.count >= 2) && singleMeasurementArray[1]) {
					id valueObject = singleMeasurementArray[1];
					measurementObject.valueString = [ILSanitizeHelpers sanitizedStringFromValue:valueObject];
					measurementObject.valueArray = [ILSanitizeHelpers sanitizedArrayFromValue:valueObject];
				}
				
				returnBlock(measurementObject, nil);
				return;
			}
		}
	} else {
		ILMeasurement *measurementObject = [[ILMeasurement alloc] initWithEventDictionary:eventDictionary];
		
		NSError *error = [NSError errorWithDomain:errorDomainString code:102 userInfo:@{NSLocalizedDescriptionKey: @"Empty measurement"}];
		returnBlock(measurementObject, error);
		return;
	}
}

#pragma mark - UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_measurementsCommonArray.count > 0) {
		return _measurementsCommonArray.count;
	} else{
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierString forIndexPath:indexPath];
	ILMeasurement *measurementObject = _measurementsCommonArray[indexPath.row];
	
	if (cell) {
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.textColor = [UIColor blackColor];
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", measurementObject.nameString, [measurementObject.date description]];
		if (measurementObject.valueString != nil) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", measurementObject.valueString, measurementObject.unitString];
			if (measurementObject.unitString == nil) {
				cell.detailTextLabel.textColor = [UIColor redColor];
			}
		} else if (measurementObject.valueArray != nil) {
			if (measurementObject.valueArray.count >= 2) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", measurementObject.valueArray[0], measurementObject.valueArray[1]];
			} else {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [measurementObject.valueArray description]];
				cell.detailTextLabel.textColor = [UIColor redColor];
			}
		} else {
			cell.detailTextLabel.text = @"NO VALUE";
			cell.detailTextLabel.textColor = [UIColor redColor];
		}
		
		if ((measurementObject.nameString == nil) ||
			(measurementObject.date == nil)) {
			cell.textLabel.textColor = [UIColor redColor];
		}
	}
	
	return cell;
}

@end
