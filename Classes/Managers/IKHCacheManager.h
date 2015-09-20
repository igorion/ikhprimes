//
//  IKHCacheManager.h
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import Foundation;


@interface IKHCacheManager : NSObject

+ (IKHCacheManager *)sharedInstance;

@property(nonatomic, strong, readonly) NSArray *arrPrimes10in7;
@property(nonatomic, assign, readonly) NSInteger primesStep;

- (void)addPrimes:(NSArray *)primes forIntervalNumber:(NSInteger)intervalNumber;
- (NSArray *)primesForIntervalNumber:(NSInteger)intervalNumber;

- (BOOL)containsPrimesInMainCacheForNum:(long long)n;

@end
