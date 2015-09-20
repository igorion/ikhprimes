//
//  IKHPrimesGenerateVC.m
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

#import "IKHPrimesGenerateVC.h"
#import "IKHSieve.h"
#import "IKHStorageHelper.h"
#import "IKHAction.h"
#import "IKHHistoryVC.h"


@interface IKHPrimesGenerateVC ()<IKHSieveDelegate>

@property(nonatomic, strong)IKHSieve *sieve;

@end


@implementation IKHPrimesGenerateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sieve = [[IKHSieve alloc] initWithTitle:@"The first"];
    _sieve.delegate = self;
    
    [_calcIndicator setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void)finishTyping{
    if([_numberTextField isFirstResponder])
        [_numberTextField resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)bgViewPressed:(id)sender {
    [self finishTyping];
}

- (IBAction)calculatePressed:(id)sender {
    if(!_numberTextField.text.length)
        return;
    
    [self finishTyping];
    
    [_calcIndicator startAnimating];
    [_calcIndicator setHidden:NO];
    
    long long number = _numberTextField.text.longLongValue;
    NSLog(@"Start calc %@ number", @(number));
    [_sieve calculate:number];
    
    //save to history
    IKHAction *act = [IKHStorageHelper createAction];
    act.data = @(number);
    act.date = [NSDate date];
    [IKHStorageHelper save];
}

- (IBAction)historyPressed:(id)sender {
    IKHHistoryVC *vc = [IKHHistoryVC new];
    [self.navigationController pushViewController:vc animated:YES];
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
    return _sieve.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
    }
    
    NSNumber *prime = _sieve.tableViewDataSource[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", prime];
    return cell;
}

#pragma mark - TextField delegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self calculatePressed:nil];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self finishTyping];
}

#pragma mark - IKHSieveDelegate methods

- (void)calculatedSieve:(IKHSieve *)sieve{
    [_primesTableView reloadData];
    
    if([_sieve isFinishedCalculation])
        [_calcIndicator stopAnimating];
}

@end
