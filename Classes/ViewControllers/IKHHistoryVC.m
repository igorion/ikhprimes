//
//  IKHHistoryVC.m
//  IKHPrimes
//
//  Created by Khmara on 20.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHHistoryVC.h"
#import "IKHStorageHelper.h"
#import "IKHAction.h"


@interface IKHHistoryVC ()

@property(nonatomic, strong)NSMutableArray *arrDataSource;

@end


@implementation IKHHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"History";
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];

    _arrDataSource = [[NSMutableArray alloc] initWithArray:[IKHStorageHelper fetchEntity:strStorageEntityAction withPredicates:nil withSortDescriptors:@[sortDescriptor]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    IKHAction *action = _arrDataSource[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", action.data];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        IKHAction *action = _arrDataSource[indexPath.row];
        
        [_arrDataSource removeObject:action];

        [IKHStorageHelper deleteObject:action];
        [IKHStorageHelper save];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
