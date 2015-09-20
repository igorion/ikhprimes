//
//  IKHSieveOperation.h
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import Foundation;

@protocol IKHSieveOperationDelegate;


@interface IKHSieveOperation : NSOperation

@property(nonatomic, assign, readonly) unsigned long intervalNumber;
@property(nonatomic, assign, readonly) unsigned long step;

@property(nonatomic, strong, readonly) NSArray *primes;

@property(nonatomic, weak) id<IKHSieveOperationDelegate> delegate;

- (id)initWithIntervalNumber:(unsigned long)intevalNumber step:(unsigned long)step primes:(NSArray *)primes_ delegate:(id<IKHSieveOperationDelegate>)delegate_;

@end


@protocol IKHSieveOperationDelegate <NSObject>

- (void)sieveOperation:(IKHSieveOperation *)oper calculatedPrimes:(NSArray *)arrPrimes;

@end
