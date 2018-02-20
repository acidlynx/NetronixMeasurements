//
//  ILSanitizeHelpers.h
//  NetronixApplication
//
//  Created by Oleg Fedjakin on 19/02/2018.
//  Copyright © 2018 Oleg Fedjakin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILSanitizeHelpers : NSObject

+(null_unspecified NSString *) sanitizedStringFromValue: (null_unspecified id) rawValue;
+(null_unspecified NSDate *) sanitizedDateFromValue: (null_unspecified id) rawValue;
+(null_unspecified NSArray *) sanitizedArrayFromValue: (null_unspecified id) rawValue;


@end
