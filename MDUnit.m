//
//  MDUnit.m
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import "MDUnit.h"

@implementation MDUnit

+ (instancetype)baseUnitWithName:(NSString *)nameBaseUnit {
    return [[MDUnit alloc] initWithName:nameBaseUnit
                                   rate:[NSDecimalNumber one]];
}

- (id)initWithName:(NSString *)name
              rate:(NSDecimalNumber *)rate {
    if(self = [super init]) {
        self->_name = [name copy];
        self->_rate = rate;
    }
    return self;
}

- (BOOL)isEqual:(MDUnit *)object {
    if(self == object) return YES;
    return ([self->_name isEqualToString:object->_name] && [self->_rate isEqualToNumber:object->_rate]);
}

- (NSUInteger)hash {
    return ([self->_name hash] + [self->_rate hash]);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, name = %@, rate = %@", [super description], self.name, self.rate];
}

@end
