//
//  IKHSieve.h
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import Foundation;

@protocol IKHSieveDelegate;


@interface IKHSieve : NSObject

@property(nonatomic, weak) id<IKHSieveDelegate> delegate;

@property(nonatomic, strong, readonly) NSMutableArray *tableViewDataSource;

- (void)calculate:(long long)n;

- (instancetype)initWithTitle:(NSString *)title;

- (BOOL)isFinishedCalculation;

@end


@protocol IKHSieveDelegate <NSObject>

- (void)calculatedSieve:(IKHSieve *)sieve;

@end
