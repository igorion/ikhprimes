//
//  IKHSieveOperation.m
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHSieveOperation.h"

@interface IKHSieveOperation()

@property(nonatomic, assign, readwrite) unsigned long intervalNumber;
@property(nonatomic, assign, readwrite) unsigned long step;

@property(nonatomic, strong, readwrite) NSArray *primes;

@end


@implementation IKHSieveOperation

- (instancetype)initWithIntervalNumber:(unsigned long)intevalNumber_ step:(unsigned long)step_ primes:(NSArray *)primes_ delegate:(id<IKHSieveOperationDelegate>)delegate_{
    if (self = [super init]) {
        self.queuePriority = NSOperationQueuePriorityLow;
        if([self respondsToSelector:@selector(qualityOfService)])
            self.qualityOfService = NSOperationQualityOfServiceBackground;
        
        self.delegate = delegate_;
        self.intervalNumber = intevalNumber_;
        self.step = step_;
        self.primes = primes_;
    }
    return self;
}

- (void)main {
    @autoreleasepool {
        if (self.isCancelled)
            return;
        
        if(_intervalNumber == 0){
            if([_delegate respondsToSelector:@selector(sieveOperation:calculatedPrimes:)]){
                [_delegate sieveOperation:self calculatedPrimes:_primes];
            }
            return;
        }
        
        NSDate *methodStart = [NSDate date];
        
        unsigned long from = _intervalNumber * _step;
        unsigned long to = _intervalNumber * _step + _step;

        bool *is_prime = (bool*)calloc((to-from+1), sizeof(bool));
        for (int i = 0; i <=to - from; i++) is_prime[i] = true;
       
        if (self.isCancelled){
            free(is_prime);
            return;
        }
        
        for(NSNumber * prime in _primes){
            unsigned long step = (unsigned long)prime.integerValue;
            unsigned long h = from % step;
            unsigned long j = h ==  0 ?  0 : step - h;
            
            for (; j<=to - from; j+=step)
                is_prime[j] = false;
        }
        
        if (self.isCancelled){
            free(is_prime);
            return;
        }
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_primes.count];
        
        for (int i = 0; i <= to - from; i++){
            if(is_prime[i])
                [arr addObject:@(from + i)];
        }

        free(is_prime);
        
        if([_delegate respondsToSelector:@selector(sieveOperation:calculatedPrimes:)]){
            [_delegate sieveOperation:self calculatedPrimes:arr];
        }
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        ;
        NSLog(@"%@", [NSString stringWithFormat:@"EXECUTE TIME = %f for interval from %@ to %@", executionTime, @(from), @(to)]);
        NSLog(@"-----------");
    }
}

@end
