//
//  MDConverter.m
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDConverter.h"

#import "XMLDictionary.h"

@implementation MDConverter

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use initWithBaseUnit:units: instead"
                                 userInfo:nil];
}
#pragma clang diagnostic pop

- (id)initWithBaseUnit:(MDUnit *)baseUnit
                 units:(NSArray<MDUnit *> *)units {
    if(self = [super init]) {
        self->_baseUnit = baseUnit;
        self->_units = [units copy];
    }
    return self;
}

- (MDUnit *)unitWithName:(NSString *)nameUnit {
    for(MDUnit *unit in self.units) {
        if([unit.name isEqualToString:nameUnit]) return unit;
    }
    return nil;
}

- (MDConversionValue *)convertWithConvertibleValue:(MDConversionValue *)convertibleValue
                                            toUnit:(MDUnit *)toUnit {
    if([convertibleValue.unit isEqual:toUnit])
        return [convertibleValue copy];
    
    NSDecimalNumber *valueInBaseUnit = [convertibleValue.value decimalNumberByDividingBy:convertibleValue.unit.rate];
    NSDecimalNumber *valueInTargerUnit = [valueInBaseUnit decimalNumberByMultiplyingBy:toUnit.rate];
    return [[MDConversionValue alloc] initWithValue:valueInTargerUnit
                                               unit:toUnit];
}

- (NSString *)description {
    NSMutableString *result = [NSMutableString stringWithFormat:@"MDConverter = %@", [super description]];
    [result appendFormat:@"\n BaseUnit = %@", [self.baseUnit description]];
    for(MDUnit *unit in self.units) {
        [result appendFormat:@"\n Unit = %@", [unit description]];
    }
    return result;
}

@end

@implementation MDConverter (MDCurrencyConverter)

+ (instancetype)ecbCurrencyConverter {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"eurofxref-daily"
                                                         ofType:@".xml"];
    XMLDictionaryParser *parser = [XMLDictionaryParser sharedInstance];
    NSDictionary *dictionary = [parser dictionaryWithFile:filePath];
    MDUnit *baseUnit = [MDUnit baseUnitWithName:@"EUR"];
    NSMutableArray <MDUnit *> *units = [[NSMutableArray alloc] init];
    for(NSDictionary *currency in dictionary[@"Cube"][@"Cube"][@"Cube"]) {
        MDUnit *currencyUnit = [[MDUnit alloc] initWithName:currency[@"_currency"]
                                                       rate:[NSDecimalNumber decimalNumberWithString:currency[@"_rate"]]];
        [units addObject:currencyUnit];
    }
    NSLog(@"%@", dictionary);
    return [[MDConverter alloc] initWithBaseUnit:baseUnit
                                           units:[units copy]];
}

@end

@implementation MDConverter (MDLenghtConverter)

+ (instancetype)lenghtConverter {
    MDUnit *baseUnit = [MDUnit baseUnitWithName:@"Meters"];
    MDUnit *kilometerUnit = [[MDUnit alloc] initWithName:@"Kilometers"
                                                    rate:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:-3 isNegative:NO]];
    MDUnit *centimeterUnit = [[MDUnit alloc] initWithName:@"Centimeters"
                                                      rate:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:2 isNegative:NO]];
    return [[MDConverter alloc] initWithBaseUnit:baseUnit
                                           units:@[kilometerUnit, centimeterUnit]];
}

@end