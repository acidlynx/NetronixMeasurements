//
//  ILQueue.h
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 20/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILQueue : NSObject

#pragma mark - Initializer
-(nonnull instancetype) initWithCapacity: (NSUInteger) capacityInteger;

#pragma mark - Public messages
-(NSArray *) getAllObjects;
-(NSUInteger) count;
-(void) enqueueObject: (nonnull id) objectForEnqueue;

@end
