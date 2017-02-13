//
//  xiuGaiViewController.h
//  weiMai1
//
//  Created by 天宏 on 15-4-24.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface xiuGaiViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView *tubiao;
@property (strong, nonatomic) IBOutlet UIView *toubuLanseView;
@property (strong, nonatomic) IBOutlet UILabel *ToubuLabel;


@property (strong, nonatomic) IBOutlet UIImageView *bk1;
@property (strong, nonatomic) IBOutlet UIImageView *bk2;
@property (strong, nonatomic) IBOutlet UIImageView *bk3;
@property (strong, nonatomic) IBOutlet UIImageView *bk4;
@property (strong, nonatomic) IBOutlet UIImageView *bk5;


@property (strong, nonatomic) IBOutlet UIImageView *suoImage;
@property (strong, nonatomic) IBOutlet UILabel *textFieldLabel1;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UITextField *textField3;
@property (strong, nonatomic) IBOutlet UITextField *textField4;
@property (strong, nonatomic) IBOutlet UITextField *textField5;

@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;

@property (strong, nonatomic) IBOutlet UIButton *yanzhengmaBtn;

@property (strong, nonatomic) IBOutlet UIButton *enterBtn;


- (IBAction)backBtnClick:(id)sender;

- (IBAction)yanzhengmaBtnClick:(id)sender;

- (IBAction)textFieldEnd:(id)sender;

- (IBAction)enterBtnClick:(id)sender;


@end
