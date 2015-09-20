//
//  IKHUtils.m
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHUtils.h"


@implementation IKHUtils

+ (NSArray *)subNumbersFromArray:(NSArray *)array fromNum:(long long)fN toNum:(long long)tN{
    if(!array)
        return nil;
    if([[array firstObject] longLongValue] >= tN)
        return nil;
    if([[array lastObject] longLongValue] <= fN)
        return nil;
    
    NSMutableArray *arr = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        if(obj.longLongValue >= fN && obj.longLongValue <=tN)
            [arr addObject:obj];
    }];
    
    return [arr copy];
}

// get from https://ru.wikipedia.org/wiki/Решето_Аткина

+ (NSArray *)atkinSieveByValue:(long long) limit{
    unsigned long primeCount = (unsigned long)(limit + 1);
    int sqr_lim;
    bool *is_prime = (bool*)calloc(primeCount, sizeof(bool));
    int x2, y2;
    int i, j;
    int n;
    
    // Инициализация решета
    sqr_lim = (int)sqrtl(limit);
    for (i = 0; i <= limit; i++) is_prime[i] = false;
    is_prime[2] = true;
    is_prime[3] = true;
    
    // Предположительно простые - это целые с нечетным числом
    // представлений в данных квадратных формах.
    // x2 и y2 - это квадраты i и j (оптимизация).
    x2 = 0;
    for (i = 1; i <= sqr_lim; i++) {
        x2 += 2 * i - 1;
        y2 = 0;
        for (j = 1; j <= sqr_lim; j++) {
            y2 += 2 * j - 1;
            
            n = 4 * x2 + y2;
            if ((n <= limit) && (n % 12 == 1 || n % 12 == 5))
                is_prime[n] = !is_prime[n];
            
            // n = 3 * x2 + y2;
            n -= x2; // Оптимизация
            if ((n <= limit) && (n % 12 == 7))
                is_prime[n] = !is_prime[n];
            
            // n = 3 * x2 - y2;
            n -= 2 * y2; // Оптимизация
            if ((i > j) && (n <= limit) && (n % 12 == 11))
                is_prime[n] = !is_prime[n];
        }
    }
    
    // Отсеиваем кратные квадратам простых чисел в интервале [5, sqrt(limit)].
    // (основной этап не может их отсеять)
    for (i = 5; i <= sqr_lim; i++) {
        if (is_prime[i]) {
            n = i * i;
            for (j = n; j <= limit; j += n) {
                is_prime[j] = false;
            }
        }
    }
    
    // Вывод списка простых чисел в консоль.
    NSMutableArray *arrPrime = [@[@(2), @(3), @(5)] mutableCopy];
    for (i = 6; i <= limit; i++) {  // добавлена проверка делимости на 3 и 5. В оригинальной версии алгоритма потребности в ней нет.
        if ((is_prime[i]) && (i % 3 != 0) && (i % 5 !=  0)){
            [arrPrime addObject:@(i)];
        }
    }
    
    free(is_prime);

    return [arrPrime copy];
}

@end
