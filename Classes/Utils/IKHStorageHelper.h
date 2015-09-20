//
//  IKHStorageHelper.h
//  IKHPrimes
//
//  Created by Khmara on 20.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import Foundation;

@class IKHAction;

extern NSString * const strStorageEntityAction;


@interface IKHStorageHelper : NSObject

+ (NSArray *)fetchEntity:(NSString *)entityName withPredicates:(id)predicates withSortDescriptors:(NSArray *)sortDescriptorArray;
+ (NSArray *)fetchEntity:(NSString *)entityName withPredicates:(id)predicates;

+ (IKHAction *)createAction;

+ (void)save;

+ (void)deleteObject:(id)object;

@end
