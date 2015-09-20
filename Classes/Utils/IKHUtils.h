//
//  IKHUtils.h
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import Foundation;


@interface IKHUtils : NSObject

+ (NSArray *)atkinSieveByValue:(long long) limit;

+ (NSArray *)subNumbersFromArray:(NSArray *)array fromNum:(long long)fN toNum:(long long)tN;

@end
