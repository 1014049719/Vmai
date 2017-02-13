//
//  LoginViewController.h
//  WeiMai
//
//  Created by 天宏 on 15-4-23.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIControl *lanbenjingView;
@property (strong, nonatomic) IBOutlet UILabel *dengluToubuLabel;
@property (strong, nonatomic) IBOutlet UIImageView *toubuLogo;


@property (strong, nonatomic) IBOutlet UITextField *textField1;
@property (strong, nonatomic) IBOutlet UITextField *textfield2;
@property (strong, nonatomic) IBOutlet UILabel *meiyouzhuceLabel;
@property (strong, nonatomic) IBOutlet UIButton *mashangzhuceBtn;
@property (strong, nonatomic) IBOutlet UIImageView *renView;
@property (strong, nonatomic) IBOutlet UIImageView *suoView;
@property (strong, nonatomic) IBOutlet UIImageView *beijing1;
@property (strong, nonatomic) IBOutlet UIImageView *beijing2;
@property (strong, nonatomic) IBOutlet UIButton *dengluBtn;
@property (strong, nonatomic) IBOutlet UIButton *wangjimimaBtn;



- (IBAction)loginBtnClick:(id)sender;

- (IBAction)TextFieldEnd:(id)sender;

- (IBAction)WangjiMiMaBtnClick:(id)sender;

- (IBAction)registerBtnClick:(id)sender;




@end
