//
//  IKHSieveOperation.h
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import Foundation;

@protocol IKHLightSieveOperationDelegate;


@interface IKHLightSieveOperation : NSOperation

@property(nonatomic, assign) long long m;

@property(nonatomic, strong) NSArray *primes;

@property(nonatomic, weak) id<IKHLightSieveOperationDelegate> delegate;

- (id)initWithToValue:(long long)m_ primes:(NSArray *)primes_ delegate:(id<IKHLightSieveOperationDelegate>)delegate_;

@end


@protocol IKHLightSieveOperationDelegate <NSObject>

- (void)lightSieveOperation:(IKHLightSieveOperation *)oper calculatedPrimes:(NSArray *)arrPrimes;

@end
