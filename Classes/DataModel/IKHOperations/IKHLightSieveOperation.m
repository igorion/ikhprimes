//
//  IKHSieveOperation.m
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHLightSieveOperation.h"

@implementation IKHLightSieveOperation

- (id)initWithToValue:(long long)m_ primes:(NSArray *)primes_ delegate:(id<IKHLightSieveOperationDelegate>)delegate_{
    if (self = [super init]) {
        self.queuePriority = NSOperationQueuePriorityLow;
        if([self respondsToSelector:@selector(qualityOfService)])
            self.qualityOfService = NSOperationQualityOfServiceBackground;
        
        self.delegate = delegate_;
        self.m = m_;
        self.primes = primes_;
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        NSMutableArray *arr = [NSMutableArray new];
        for(NSNumber *num in _primes){
            if(num.integerValue <= _m)
                [arr addObject:num];
            else
                break;
        }

        if (self.isCancelled)
            return;
        
        if([_delegate respondsToSelector:@selector(lightSieveOperation:calculatedPrimes:)])
            [_delegate lightSieveOperation:self calculatedPrimes:[arr copy]];
    }
}

@end
