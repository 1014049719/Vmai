//
//  WangjiMiMaViewController.m
//  weiMai1
//
//  Created by 天宏 on 15-4-27.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "WangjiMiMaViewController.h"
#import <Masonry.h>
#import "AlterView.h"
#import "PublicToolClass.h"
#import <SMS_SDK/SMS_SDK.h>
#import <AddressBook/AddressBook.h>


#define wangjiMiMaUrl @"http://120.24.228.254/VMai/user/JsonForgetPassword"

@interface WangjiMiMaViewController ()<UITextFieldDelegate>
{
    //输入textField内容
    NSString *_str1;
    NSString *_str2;
    NSString *_str3;
    NSString *_str4;
    NSString *_str5;
   
}
@end

@implementation WangjiMiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _textField1.delegate=self;
    _textField2.delegate=self;
    _textField3.delegate=self;
    _textField4.delegate=self;
    _textField5.delegate=self;
    
    //界面布局
    [self.toubuLanseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view);
    }];
    [self.ToubuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(101, 24));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_toubuLanseView).offset(-5);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 42));
        make.left.equalTo(self.toubuLanseView).offset(8);
        make.bottom.equalTo(self.toubuLanseView).offset(-5);
    }];
    [self.tubiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 50));
        make.centerY.equalTo(self.ToubuLabel).offset(5);
        make.right.equalTo(self.view).offset(-8);
        
    }];
    
    //下方
    [self.bk1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(106);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(55);
        make.right.equalTo(self.view).offset(-55);
        if ([UIScreen mainScreen].bounds.size.height<=568) {
            make.height.mas_equalTo(38);
        }
        else{
            make.height.mas_equalTo(48);
        }
    }];
    [self.bk2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bk1);
        make.top.equalTo(self.bk1.mas_bottom).offset(5);
        make.centerX.equalTo(self.bk1);
    }];
    [self.bk3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bk1);
        make.top.equalTo(self.bk2.mas_bottom).offset(4);
        make.centerX.equalTo(self.bk1);
    }];
    [self.bk4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bk1);
        make.top.equalTo(self.bk3.mas_bottom).offset(5);
        make.centerX.equalTo(self.bk1);
    }];
    [self.bk5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bk1);
        make.top.equalTo(self.bk4.mas_bottom).offset(4);
        make.centerX.equalTo(self.bk1);
    }];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.bk1);
        make.top.equalTo(self.bk5.mas_bottom).offset(43);
        make.centerX.equalTo(self.bk1);
    }];
    
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.bk1).offset(8);
        make.centerY.equalTo(self.bk1);
    }];
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.bk2).offset(8);
        make.centerY.equalTo(self.bk2);
    }];
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.bk3).offset(8);
        make.centerY.equalTo(self.bk3);
    }];
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.bk4).offset(8);
        make.centerY.equalTo(self.bk4);
    }];
    [self.image5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.left.equalTo(self.bk5).offset(8);
        make.centerY.equalTo(self.bk5);
    }];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.mas_right).offset(5);
        make.right.equalTo(self.bk1.mas_right).offset(-5);
        make.centerY.equalTo(self.bk1);
    }];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.textField1);
        make.left.equalTo(self.image2.mas_right).offset(5);
        make.centerY.equalTo(self.bk2);
    }];
    [self.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.textField1);
        make.left.equalTo(self.image3.mas_right).offset(5);
        make.centerY.equalTo(self.bk3);
    }];
    [self.textField4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image4.mas_right).offset(5);
        make.right.equalTo(self.yanzhengmaBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.bk4);
    }];
    [self.textField5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.textField1);
        make.left.equalTo(self.image5.mas_right).offset(5);
        make.centerY.equalTo(self.bk5);
    }];
    
    [self.yanzhengmaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bk1);
        make.width.mas_equalTo(77);
        make.right.equalTo(self.bk4.mas_right);
        make.centerY.equalTo(self.bk4);
    }];

}

//上传数据
-(void)requestDataWithUlrStr:(NSString *)urlString{
    
    NSDictionary *dic=@{@"username":_str1,@"phone":_str4,@"newPassword":_str3};
    [PublicToolClass myDataRequestWithUrlString:urlString andWithParameter:dic andSuccessBlock:^(id data) {
        
        NSLog(@"%@",data);
        //请求成功 关闭网络连接浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        
        if ([data[@"result"] isEqualToString:@"1"]) {
            
            [AlterView AlterViewShowWithMesssge:@"现在开始使用吧"];
        }
        else{
            [AlterView AlterViewShowWithMesssge:@"请检查输入格式"];
        }

} andFailBlock:^(NSError *error) {
        NSLog(@"请求失败%@",error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//控制键盘相关
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([UIScreen mainScreen].bounds.size.height<=480) {
        if (textField.tag>=103) {
            [_bk1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(240, 35));
                make.top.mas_equalTo(106-40);
                make.centerX.equalTo(self.view);
            }];
        }
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([UIScreen mainScreen].bounds.size.height<=480) {
        if (textField.tag>=103) {
            [_bk1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(240, 35));
                make.top.mas_equalTo(106);
                make.centerX.equalTo(self.view);
            }];
        }
    }
    
}

//验证码
- (IBAction)yanzhengmaBtnClick:(id)sender{
    
    _str4=_textField4.text;
    //发送验证码
    [SMS_SDK getVerificationCodeBySMSWithPhone:_str4
                                          zone:@"86"
                                        result:^(SMS_SDKError *error)
     {
         if (!error)
         {
             NSLog(@"获取验证码成功");
         }
         else
         {
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                           message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                 otherButtonTitles:nil, nil];
             [alert show];
         }
         
     }];

    
}

//确认修改
- (IBAction)enterBtnClick:(id)sender {
    
    _str1=_textField1.text;
    _str2=_textField2.text;
    _str3=_textField3.text;
    _str4=_textField4.text;
    _str5=_textField5.text;
    
    
    NSLog(@"点击了提交注册");
    
    
    //核对验证码
    [SMS_SDK commitVerifyCode:_str5 result:^(enum SMS_ResponseState state) {
        if (1==state)
        {
            NSLog(@"验证成功");
            
            //弹出网络连接浮框
            [AlterView showMBProgessHUDSuperView:self.view animate:YES];
            [self requestDataWithUlrStr:wangjiMiMaUrl];
            
        }
        else if(0==state)
        {
            NSLog(@"验证失败");
        }
    }];

    
}


//退回键盘
- (IBAction)textFieldEnd:(id)sender {
    
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
    [_textField5 resignFirstResponder];
    
    
}
//返回
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
