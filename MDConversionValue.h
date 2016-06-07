//
//  MDConversionValue.h
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDUnit.h"

@interface MDConversionValue : NSObject

- (id)initWithValue:(NSDecimalNumber *)value
               unit:(MDUnit *)unit NS_DESIGNATED_INITIALIZER;
- (id)initWithNumberValue:(NSNumber *)numberValue
                     unit:(MDUnit *)unit;
- (id)initWithStringValue:(NSString *)stringValue
                     unit:(MDUnit *)unit;

- (NSString *)stringValue;

@property (nonatomic, readonly) NSDecimalNumber *value;
@property (nonatomic, readonly) MDUnit *unit;

@end
