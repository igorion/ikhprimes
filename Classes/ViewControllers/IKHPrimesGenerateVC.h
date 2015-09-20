//
//  IKHPrimesGenerateVC.h
//  IKHPrimes
//
//  Created by Khmara on 18.09.15.
//  Copyright (c) 2015 Khmara. All rights reserved.
//

@import UIKit;


@interface IKHPrimesGenerateVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *primesTableView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *calcIndicator;

- (IBAction)bgViewPressed:(id)sender;
- (IBAction)calculatePressed:(id)sender;
- (IBAction)historyPressed:(id)sender;

@end
