//
//  MDUnit.h
//  Converter2GIS
//
//  Created by Dmitry on 01.06.16.
//  Copyright © 2016 MakarovDmitry. All rights reserved.
//

#import <Foundation/Foundation.h>

//Unit - единица измерения
@interface MDUnit : NSObject

+ (instancetype)baseUnitWithName:(NSString *)nameBaseUnit;

- (id)initWithName:(NSString *)name
              rate:(NSDecimalNumber *)rate;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSDecimalNumber *rate;

@end
