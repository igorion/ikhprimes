//
//  IKHSieve.m
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHSieve.h"
#import "IKHCacheManager.h"
#import "IKHSieveOperation.h"
#import "IKHLightSieveOperation.h"
#import "IKHUtils.h"

static const NSInteger kQueueOperationsMax = 5;

@interface IKHSieve () <IKHSieveOperationDelegate, IKHLightSieveOperationDelegate>

@property(nonatomic, strong) NSOperationQueue *workQueue;

@property(nonatomic, strong, readwrite) NSMutableArray *tableViewDataSource;              //need for table view

@property(nonatomic, assign) unsigned long calculatingIntervalsCount;        //steps number for calculation primes for big value >10^9
@property(nonatomic, assign) unsigned long calculatingIntervalNumber;
@property(nonatomic, assign) long long goal;
@property(nonatomic, assign) unsigned long bigNumberPrimesCount;

@property(nonatomic, assign) BOOL calculatingBigNum;

@end


@implementation IKHSieve

- (instancetype)initWithTitle:(NSString *)title{
    if(self = [super init]){
        _workQueue = [[NSOperationQueue alloc] init];
        _workQueue.name = [NSString stringWithFormat:@"Working queue %@", title];
        _workQueue.maxConcurrentOperationCount = 5;
        
        _tableViewDataSource = [NSMutableArray new];
        
        _calculatingIntervalNumber = 0;
        
        _calculatingBigNum = NO;
    }
    return self;
}

- (void)resetCalculatingData{
    [_workQueue cancelAllOperations];

    self.calculatingBigNum = NO;
    self.calculatingIntervalsCount = 0;
    self.calculatingIntervalNumber = 0;
    self.bigNumberPrimesCount = 0;
    
    [_tableViewDataSource removeAllObjects];
}

- (void)calculate:(long long)n{
    if([[IKHCacheManager sharedInstance] containsPrimesInMainCacheForNum:n]){
        [self resetCalculatingData];
        
        IKHLightSieveOperation *oper = [[IKHLightSieveOperation alloc] initWithToValue:n primes:[IKHCacheManager sharedInstance].arrPrimes10in7 delegate:self];
        
        [_workQueue addOperation:oper];
    }
    else if(n < _goal){
        [self resetCalculatingData];
        self.goal = n;
        [self calculate:n];
        return;
    }
    else{
        if(!_calculatingBigNum || !_workQueue.operationCount){
            [self resetCalculatingData];
            self.calculatingBigNum = YES;
        }
        
        self.calculatingIntervalsCount = ceill(n / [IKHCacheManager sharedInstance].primesStep);
        NSLog(@"Need calculate %@ intervals", @(_calculatingIntervalsCount));
        [self calculateNextInterval];
    }
    
    self.goal = n;
}

- (void)calculateNextInterval{
    //if there is primes for interval
    id primes = [[IKHCacheManager sharedInstance] primesForIntervalNumber:_calculatingIntervalNumber];
    if(primes){
        _calculatingIntervalNumber++;
        [self processingCalculatedPrimes:primes forIntervalNumber:_calculatingIntervalNumber-1];
        return;
    }
    
    NSInteger step = [IKHCacheManager sharedInstance].primesStep;
    NSArray *arrCachePrimes = [IKHCacheManager sharedInstance].arrPrimes10in7;
    
    for(NSInteger i = _workQueue.operationCount; i <= kQueueOperationsMax; i++){
        if(_calculatingIntervalNumber > _calculatingIntervalsCount)
            break;
        
        IKHSieveOperation *oper = [[IKHSieveOperation alloc] initWithIntervalNumber:_calculatingIntervalNumber step:step primes:arrCachePrimes delegate:self];
        
        _calculatingIntervalNumber++;
        
        [self.workQueue addOperation:oper];
    }
}

- (void)processingCalculatedPrimes:(NSArray *)primes forIntervalNumber:(NSInteger)intNum{
    if(_workQueue.operationCount <= kQueueOperationsMax)
        [self calculateNextInterval];
    
    //reload table for primes from first 10^7 number
    if(intNum == 0){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [_tableViewDataSource removeAllObjects];
            [_tableViewDataSource addObjectsFromArray:primes];
            
            if([_delegate respondsToSelector:@selector(calculatedSieve:)])
                [_delegate calculatedSieve:self];
        }];
    }
    
    if(intNum == _calculatingIntervalsCount - 1){           //last interval
        NSArray *arrPrimesFromLastInterval = [IKHUtils subNumbersFromArray:primes fromNum:[[IKHCacheManager sharedInstance] primesStep] * intNum  toNum:_goal];
        NSLog(@"Last prime number %@", [arrPrimesFromLastInterval lastObject]);
        NSLog(@"There are %@ primes in last interval", @([arrPrimesFromLastInterval count]));
        NSLog(@"Finished calculating primes");
        NSLog(@"--  --  --  --  --  --  --  --");
        NSLog(@"");
        
        //update table data
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if([_delegate respondsToSelector:@selector(calculatedSieve:)])
                [_delegate calculatedSieve:self];
        }];
    }
}

- (BOOL)isFinishedCalculation{
    return !_workQueue.operationCount;
}

#pragma mark - IKHLightSieveOperationDelegate methods

- (void)lightSieveOperation:(IKHLightSieveOperation *)oper calculatedPrimes:(NSArray *)arrPrimes{    
    //update result table view
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [_tableViewDataSource removeAllObjects];
        [_tableViewDataSource addObjectsFromArray:arrPrimes];

        if([_delegate respondsToSelector:@selector(calculatedSieve:)])
            [_delegate calculatedSieve:self];
    }];
}

#pragma mark - IKHSieveOperationDelegate methods

- (void)sieveOperation:(IKHSieveOperation *)oper calculatedPrimes:(NSArray *)arrPrimes{
    @synchronized(self){
        NSLog(@"There are %@ operations in  queue", @(_workQueue.operationCount));
        NSLog(@"Got %@ primes count", @(arrPrimes.count));
        NSLog(@"Last got value %@", arrPrimes.lastObject);
        NSLog(@"Calculated interval number %@", @(oper.intervalNumber));
        
        _bigNumberPrimesCount += arrPrimes.count;
        
        [[IKHCacheManager sharedInstance] addPrimes:arrPrimes forIntervalNumber:oper.intervalNumber];
        
        [self processingCalculatedPrimes:arrPrimes forIntervalNumber:oper.intervalNumber];
    }
}

@end
