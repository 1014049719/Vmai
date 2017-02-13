//
//  registerViewController.m
//  WeiMai
//
//  Created by 天宏 on 15-4-24.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "registerViewController.h"
#import <Masonry.h>
#import <AFNetworking.h>
#import "PublicToolClass.h"
#import "AlterView.h"
#import "LoginViewController.h"

#import <SMS_SDK/SMS_SDK.h>
#import <AddressBook/AddressBook.h>

#define registUrl @"http://120.24.228.254/VMai/user/JsonRegUser"

@interface registerViewController ()<UITextFieldDelegate>
{
    //输入textField内容
    NSString *_str1;
    NSString *_str2;
    NSString *_str3;
    NSString *_str4;
    NSString *_str5;
    
   //验证码计时器
    NSTimer *_timer;
    
    //验证码开关
    BOOL _isYanzheng;
}

@end

@implementation registerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textField1.delegate=self;
    _textField2.delegate=self;
    _textField3.delegate=self;
    _textField4.delegate=self;
    _textField5.delegate=self;

    _isYanzheng=NO;
    
    //界面布局
    [self.toubuLanseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view);
    }];
    [self.ToubuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 24));
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
    
    NSDictionary *dic=@{@"username":_str1,@"password":_str3,@"phone":_str4,@"inviter":@""};
    [PublicToolClass myDataRequestWithUrlString:urlString andWithParameter:dic andSuccessBlock:^(id data) {
        
        NSLog(@"网络请求成功%@",data);
        
        //请求成功 隐藏浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        
        if ([data[@"result"] isEqualToString:@"1"]) {
            
            
            //跳入登录界面
            LoginViewController *loginVcl=[[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVcl animated:YES];
            
            //一次获得
//            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//                NSLog(@"%@", cookie);
//            }
            //修改cookie
//            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//            //            [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
//            [cookieProperties setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
//            [cookieProperties setObject:data[@"entity"][@"JSESSIONID"] forKey:NSHTTPCookieValue];
//            [cookieProperties setObject:@"120.24.228.254" forKey:NSHTTPCookieDomain];
//            //[cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
//            [cookieProperties setObject:@"/VMai/" forKey:NSHTTPCookiePath];
//            //            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//            [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*30] forKey:NSHTTPCookieExpires];
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            NSLog(@"。。。。。。%@", cookie);
        }
        
        else{
            
            [AlterView AlterViewShowWithMesssge:@"请检查注册信息格式"];
        }
        ;
    } andFailBlock:^(NSError *error) {
        NSLog(@"请求失败%@",error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
//返回
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//验证码按钮
- (IBAction)yanzhengmaBtnClick:(id)sender {
    
    _str4=_textField4.text;
    
    if (_isYanzheng==NO) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Jishiqi) userInfo:nil repeats:YES];
        [_timer fire];
        
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
                 NSLog(@"获取验证码失败");
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                               message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
    
    _isYanzheng=YES;
   
}
//计时开始
-(void)Jishiqi{

    static int a=60;
    a--;
    [_yanzhengmaBtn setEnabled:NO];
    [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%d(S)",a] forState:UIControlStateNormal];
//    NSLog(@"%d(S)",a);
    
    if (a<=0) {
        a=60;
        [_yanzhengmaBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_yanzhengmaBtn setEnabled:YES];
        [_timer invalidate];
//        return;
    }
//    return;
    
}
//退回键盘
- (IBAction)textFieldEnd:(id)sender {
    
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
    [_textField5 resignFirstResponder];
  

}

//确认
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
            
            [AlterView showMBProgessHUDSuperView:self.view animate:YES];
            //请求注册信息
            [self requestDataWithUlrStr:registUrl];
            
        }
        else if(0==state)
        {
            NSLog(@"验证失败");
        }
    }];

}
@end
