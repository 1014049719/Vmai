//
//  TongjirenmaiViewController.h
//  weiMai1
//
//  Created by 天宏 on 15-4-28.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TongjirenmaiViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView *tubiao;
@property (strong, nonatomic) IBOutlet UIView *toubuLanseView;
@property (strong, nonatomic) IBOutlet UILabel *ToubuLabel;

@property (strong, nonatomic) IBOutlet UIImageView *sousuoBeijing;
@property (strong, nonatomic) IBOutlet UILabel *sousuoLabel;
@property (strong, nonatomic) IBOutlet UITextField *sousuoTextfield;
@property (strong, nonatomic) IBOutlet UIButton *sousuoImageView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)sousuoBtnClick:(id)sender;


- (IBAction)backBtnClick:(id)sender;

@end
