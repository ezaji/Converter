//
//  MDConverter.h
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDConversionValue.h"

@interface MDConverter : NSObject

//Init method throw exception. Must use this method.
- (id)initWithBaseUnit:(MDUnit *)baseUnit
                 units:(NSArray <MDUnit *> *)units NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) MDUnit *baseUnit;
//Rate для units формируется исходя из базовой единицы измерения.
//Т. е. 1 единица baseUnit = x единиц unit.
//Например: если baseUnit = метр, то для unit = километр, unit.rate = 10^(-3).
@property (nonatomic, copy, readonly) NSArray <MDUnit *> *units;
- (MDUnit *)unitWithName:(NSString *)nameUnit;

- (MDConversionValue *)convertWithConvertibleValue:(MDConversionValue *)convertibleValue
                                            toUnit:(MDUnit *)toUnit;

@end

@interface MDConverter (MDCurrencyConverter)

+ (instancetype)ecbCurrencyConverter;

@end

@interface MDConverter (MDLenghtConverter)

+ (instancetype)lenghtConverter;

@end