//
//  Measurement.h
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 18/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILMeasurement : NSObject
@property (nullable) NSString	*timeSerieIdString;
@property (nullable) NSString	*nameString;
@property (nullable) NSDate		*date;
@property (nullable) NSString	*unitString;
@property (nullable) NSString	*valueString;
@property (nullable) NSArray	*valueArray;

#pragma mark - initializers
-(nonnull instancetype) initWithEventDictionary: (null_unspecified NSDictionary *) eventDictionary;

#pragma mark - Public messages
-(void) setMeausrementValueWithObject: (null_unspecified id) valueObject;


@end
