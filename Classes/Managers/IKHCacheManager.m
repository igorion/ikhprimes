//
//  IKHCacheManager.m
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHCacheManager.h"
#import "IKHUtils.h"

static IKHCacheManager *instance = nil;

static const NSInteger kPrimesStepMax = 10000000; //using 10^7, because primes numbers calculate fast and use low memory in this interval
static const NSInteger kIntervalsLimit = 10;

@interface IKHCacheManager()

@property(nonatomic, strong, readwrite) NSArray *arrPrimes10in7;

@property(nonatomic, assign, readwrite) NSInteger primesStep;

@property(nonatomic, strong)NSMutableDictionary *primesForIntervalsDictionary;

@end


@implementation IKHCacheManager

#pragma mark - Singleton Instance

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init {
    if (self = [super init])
    {
        self.primesForIntervalsDictionary = [NSMutableDictionary new];
        self.primesStep = kPrimesStepMax;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDate *methodStart = [NSDate date];

            self.arrPrimes10in7 = [IKHUtils atkinSieveByValue:_primesStep];
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            NSLog(@"Calculate primes [0, %@] time %f", @(_primesStep), executionTime);

        });
    }
    return self;
}

- (void)addPrimes:(NSArray *)primes forIntervalNumber:(NSInteger)intervalNumber{
    if(!primes)
        return;
    
    [_primesForIntervalsDictionary setObject:primes forKey:@(intervalNumber)];
    
    if(_primesForIntervalsDictionary.allKeys.count >= kIntervalsLimit){
        
        NSNumber *minKey = [_primesForIntervalsDictionary.allKeys firstObject];
        
        for(NSNumber *key in _primesForIntervalsDictionary.allKeys)
            minKey = @(MIN(minKey.integerValue, key.integerValue));
        
        [_primesForIntervalsDictionary removeObjectForKey:minKey];
    }
}

- (NSArray *)primesForIntervalNumber:(NSInteger)intervalNumber{
    if(!intervalNumber)
        return _arrPrimes10in7;
    else
        return _primesForIntervalsDictionary[@(intervalNumber)];
}

- (BOOL)containsPrimesInMainCacheForNum:(long long)n{
    NSArray *arrCachePrimes = [IKHCacheManager sharedInstance].arrPrimes10in7;
    long long lastNum = [[arrCachePrimes lastObject] longLongValue];
    return n <=lastNum;
}

@end
