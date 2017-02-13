//
//  xiuGaiViewController.m
//  weiMai1
//
//  Created by 天宏 on 15-4-24.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "xiuGaiViewController.h"
#import "MyDataCenter.h"
#import "PublicToolClass.h"
#import <Masonry.h>
#import "AlterView.h"

#define xiugaiUrl @"http://120.24.228.254/VMai/user/JsonEditPassword"


@interface xiuGaiViewController ()<UITextFieldDelegate>
{
    //输入密码内容
    NSString *_str;

    //验证码计时器
    NSTimer *_timer;
}
@end

@implementation xiuGaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    [self.suoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.right.equalTo(self.textFieldLabel1).offset(-8);
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
    
    [self.textFieldLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.mas_right).offset(5);
        make.right.equalTo(self.bk1.mas_right).offset(-5);
        make.centerY.equalTo(self.bk1);
    }];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.textFieldLabel1);
        make.left.equalTo(self.image2.mas_right).offset(5);
        make.centerY.equalTo(self.bk2);
    }];
    [self.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.textFieldLabel1);
        make.left.equalTo(self.image3.mas_right).offset(5);
        make.centerY.equalTo(self.bk3);
    }];
    [self.textField4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image4.mas_right).offset(5);
        make.right.equalTo(self.yanzhengmaBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.bk4);
    }];
    [self.textField5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.textFieldLabel1);
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
    
    NSDictionary *dic=@{@"newPassword":_str};
    [PublicToolClass myDataRequestWithUrlString:urlString andWithParameter:dic andSuccessBlock:^(id data) {
        
        NSLog(@"%@",data);
        //请求成功 关闭网络连接浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        
        if ([data[@"result"] isEqualToString:@"1"]) {
            
            [AlterView AlterViewShowWithMesssge:@"信息修改成功"];
        }
        else{
            [AlterView AlterViewShowWithMesssge:@"请检查输入格式"];
        }
        
    } andFailBlock:^(NSError *error) {
        NSLog(@"修改密码请求失败%@",error);
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

//验证码
- (IBAction)yanzhengmaBtnClick:(id)sender{
   
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Jishiqi) userInfo:nil repeats:YES];
    [_timer fire];
}
//计时开始
-(void)Jishiqi{
    
    static int a=61;
    a--;
    [_yanzhengmaBtn setEnabled:NO];
    [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%d(S)",a] forState:UIControlStateNormal];
    
    if (a<=0) {
        [_timer invalidate];
        [_yanzhengmaBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_yanzhengmaBtn setEnabled:YES];
    }
    
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
//返回
- (IBAction)backBtnClick:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

//确认修改
- (IBAction)enterBtnClick:(id)sender {
    
    _str=_textField3.text;
    
    //弹出网络连接浮框
    [AlterView showMBProgessHUDSuperView:self.view animate:YES];
    
    [self requestDataWithUlrStr:xiugaiUrl];
    
}
//退回键盘
- (IBAction)textFieldEnd:(id)sender {
    
    [_textField2 resignFirstResponder];
    [_textField3 resignFirstResponder];
    [_textField4 resignFirstResponder];
    [_textField5 resignFirstResponder];
    
    
}
@end
