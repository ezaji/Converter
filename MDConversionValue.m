//
//  MDConversionValue.m
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDConversionValue.h"

@implementation MDConversionValue

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use initWithBaseUnit:units: instead"
                                 userInfo:nil];
}
#pragma clang diagnostic pop

- (id)initWithValue:(NSDecimalNumber *)value
               unit:(MDUnit *)unit {
    if(self = [super init]) {
        self->_value = value;
        self->_unit = unit;
    }
    return self;
}

- (id)initWithNumberValue:(NSNumber *)numberValue
                     unit:(MDUnit *)unit {
    return [self initWithValue:[NSDecimalNumber decimalNumberWithDecimal:[numberValue decimalValue]]
                          unit:unit];
}

- (id)initWithStringValue:(NSString *)stringValue unit:(MDUnit *)unit {
    return [self initWithValue:[NSDecimalNumber decimalNumberWithString:stringValue]
                          unit:unit];
}

- (NSString *)stringValue {
    NSMutableString *result = [NSMutableString stringWithFormat:@"%.2f", self->_value.doubleValue];
    [result appendFormat:@" %@", self->_unit.name];
    return [result copy];
}

- (NSAttributedString *)attributedStringValue {
    
    return nil;
}

- (id)copy {
    return [[MDConversionValue alloc] initWithValue:self->_value
                                               unit:self->_unit];
}

@end
