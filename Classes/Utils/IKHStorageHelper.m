//
//  IKHStorageHelper.m
//  IKHPrimes
//
//  Created by Khmara on 20.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHStorageHelper.h"
#import "IKHAction.h"
#import "AppDelegate.h"

NSString * const strStorageEntityAction = @"IKHAction";


@implementation IKHStorageHelper

+ (void)deleteObject:(id)object
{
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [context deleteObject:object];
}

+ (NSArray *)fetchEntity:(NSString *)entityName withPredicates:(id)predicates
{
    return [self fetchEntity:entityName withPredicates:predicates withSortDescriptors:nil];
}

+ (NSArray *)fetchEntity:(NSString *)entityName withPredicates:(id)predicates withSortDescriptors:(NSArray *)sortDescriptorArray
{
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);

    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // Setting up type of return value and target context
    id entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    
    // Setting up predicate
    if ([predicates isKindOfClass:[NSArray class]])
    {
        [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
    }
    else if ([predicates isKindOfClass:[NSPredicate class]])
    {
        [request setPredicate:predicates];
    }
    
    // Setting up sorting descriptors
    [request setSortDescriptors:sortDescriptorArray];
    // Fetch result
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Fetch request failed: %@", [error description]);
        return nil;
    }
    else
    {
        return result;
    }
}

+ (IKHAction *)createAction
{
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    
    NSEntityDescription *elementEntityDescription = [NSEntityDescription entityForName:strStorageEntityAction inManagedObjectContext:appDelegate.managedObjectContext];
    IKHAction *act = [[IKHAction alloc] initWithEntity:elementEntityDescription insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    
    return act;
}

+ (void)save{
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [appDelegate.managedObjectContext save:nil];
}


@end
