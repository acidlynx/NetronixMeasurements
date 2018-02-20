//
//  ILQueue.m
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 20/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import "ILQueue.h"

@implementation ILQueue {
	NSMutableArray *_queueMutableArray;
	NSUInteger _capacityInteger;
}

#pragma mark - initializers
-(instancetype) initWithCapacity: (NSUInteger) capacityInteger {
	self = [super init];
	if (self) {
		if (capacityInteger > 0) {
			_capacityInteger = capacityInteger;
			_queueMutableArray = [[NSMutableArray alloc] init];
		}
	}
	
	return self;
}

#pragma mark - Public messages
-(NSArray *) getAllObjects {
//	NSArray *_objectsArray = [NSArray arrayWithArray:_queueMutableArray];
//	return _objectsArray;
	
	return (NSArray *)_queueMutableArray;
}

-(NSUInteger) count {
	return _queueMutableArray.count;
}

-(void) enqueueObject: (nonnull id) objectForEnqueue {
	if (_queueMutableArray.count < _capacityInteger) {
		[_queueMutableArray insertObject:objectForEnqueue atIndex:0];
	} else if (_queueMutableArray.count >= _capacityInteger) {
		@try {
			if (_queueMutableArray[_queueMutableArray.count - 1]) {
				[_queueMutableArray removeLastObject];
			}
		} @catch (NSException *exception) {
			NSLog(@"exception: %@", exception);
		} @finally {
			
		}
		
		[_queueMutableArray insertObject:objectForEnqueue atIndex:0];
	}
}

@end