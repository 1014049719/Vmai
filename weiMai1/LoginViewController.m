//
//  LoginViewController.m
//  WeiMai
//
//  Created by 天宏 on 15-4-23.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "registerViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking.h>
#import "MyDataCenter.h"
#import "PublicToolClass.h"
#import <CoreLocation/CoreLocation.h>
#import <Masonry.h>
#import "AlterView.h"
#import "WangjiMiMaViewController.h"


#define loginUrl @"http://120.24.228.254/VMai/user/JsonUserLogin"

#define WeizhiUrl @"http://120.24.228.254/VMai/user/updateLocal"

@interface LoginViewController ()<CLLocationManagerDelegate>
{
    NSMutableString *_ret;
    NSString *_str1;
    NSString *_str2;
    
    //本地联系人字典
    NSMutableDictionary *_Dic;
    //缓存状态
    NSUserDefaults *_userDefault;
    //状态数字
    int _a;
    
    //设备ID保存
    NSString *_deviceID;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _userDefault=[NSUserDefaults standardUserDefaults];
    _a=[_userDefault boolForKey:@"MoshiKaiguan"];
    NSLog(@"开关状态%d",_a);
    
    //给用户名密码赋缓存值
    _textField1.text=[_userDefault objectForKey:@"username"];
    _textfield2.text=[_userDefault objectForKey:@"password"];
    
    //获取设备ID
    _deviceID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"%@",_deviceID);
    
    
    //界面布局
    [self.lanbenjingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view);
    }];
    [self.dengluToubuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 24));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_lanbenjingView).offset(-5);
    }];
    [self.toubuLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 50));
        make.centerY.equalTo(self.dengluToubuLabel).offset(5);
        make.right.equalTo(self.view).offset(-8);
    }];
    
    [self.beijing1 mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([UIScreen mainScreen].bounds.size.height>=736) {
            make.height.mas_equalTo(48);
            NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
        }
        else{
            make.height.mas_equalTo(40);
            NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
        }
        make.left.equalTo(self.view).offset(55);
        make.right.equalTo(self.view).offset(-55);
        make.top.equalTo(self.lanbenjingView).offset(100);
    }];
    [self.beijing2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_beijing1);
        make.centerX.equalTo(_beijing1);
        make.top.equalTo(_beijing1.mas_bottom).offset(15);
    }];
    [self.renView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerY.equalTo(_beijing1);
        make.left.equalTo(_beijing1).offset(8);
    }];
    [self.suoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerY.equalTo(_beijing2);
        make.left.equalTo(_beijing1).offset(8);
    }];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_renView.mas_right).offset(8);
        make.right.equalTo(_beijing1).offset(-8);
        make.centerY.equalTo(_beijing1);
        make.left.equalTo(_renView.mas_right).offset(8);
    }];
    [self.textfield2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_renView.mas_right).offset(8);
        make.right.equalTo(_beijing1).offset(-8);
        make.centerY.equalTo(_beijing2);
        make.left.equalTo(_suoView.mas_right).offset(8);
    }];
    
    [self.wangjimimaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(89, 33));
        make.top.equalTo(_beijing2.mas_bottom).offset(5);
        make.right.equalTo(self.beijing2).offset(10);
    }];
    [self.meiyouzhuceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 21));
        make.left.equalTo(self.beijing2);
        make.centerY.equalTo(self.wangjimimaBtn);
    }];
    [self.mashangzhuceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 39));
        make.left.equalTo(self.meiyouzhuceLabel.mas_right).offset(-3);
        make.centerY.equalTo(_meiyouzhuceLabel);
    }];
    
    [self.dengluBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_beijing1);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.beijing2.mas_bottom).offset(85);
        
    }];


    
    
}


//密码进行 MD5加密
-(NSString *)md5:(NSString *)inputStr
{
    
    const char* str = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    _ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [_ret appendFormat:@"%02X",result[i]];
    }
    return _ret;
    
}

//上传数据登录
-(void)requestDataWithUlrStr:(NSString *)urlString{
    
    [self md5:_str2];
    
//    NSDictionary *dic=@{@"username":_str1,@"password":_ret,@"device":_deviceID};
    /**********测试用***************/
    NSDictionary *dic=@{@"username":_str1,@"password":_ret,@"device":@"2AC80EBF-781A-432A-AB0D-25C69F38865F"};
    [PublicToolClass myDataRequestWithUrlString:urlString andWithParameter:dic andSuccessBlock:^(id data) {
        
        NSLog(@"登录网络请求成功%@",data);
        
        //请求成功 隐藏浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        
                if ([data[@"result"] isEqualToString:@"1"]) {
                    //单利传值
                    [MyDataCenter defaultcenter].infoStr=data[@"entity"][@"JSESSIONID"];
                    
                    //存储用户名密码
                    [_userDefault setObject:_str1 forKey:@"username"];
                    [_userDefault setObject:_str2 forKey:@"password"];
                    [_userDefault synchronize];
        
                    //验证通过跳转
                    MainViewController *mainVCl=[[MainViewController alloc] init];
                    mainVCl.TouxiangnameStr=data[@"entity"][@"head"];
                    mainVCl.nicknameStr=_str1;
                    
//                    mainVCl.nicknameStr=data[@"entity"][@"nickname"];
                    mainVCl.jobStr=data[@"entity"][@"job"];
                    mainVCl.noteStr=data[@"entity"][@"note"];
                    
                    //登录成功更新位置
                    [self gengxinWeizhiUrlWithUlrStr:WeizhiUrl];
                    
                    [self.navigationController pushViewController:mainVCl animated:YES];
                    
                                        
                    //一次获得
//                    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//                                        NSLog(@"%@", cookie);
//                    }
//                    //修改cookie
//                    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//        //            [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
//                    [cookieProperties setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
//                    [cookieProperties setObject:data[@"entity"][@"JSESSIONID"] forKey:NSHTTPCookieValue];
//                    [cookieProperties setObject:@"120.24.228.254" forKey:NSHTTPCookieDomain];
//                    //[cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
//                    [cookieProperties setObject:@"/VMai/" forKey:NSHTTPCookiePath];
//        //            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//                    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*30] forKey:NSHTTPCookieExpires];
//                    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//                     NSLog(@"。。。。。。%@", cookie);
        
                    //清空cookie
//                    NSHTTPCookieStorage *cookieJar1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar1 cookies]];
//                    for (id obj in _tmpArray) {
//                        [cookieJar deleteCookie:obj];
//                    }
        
}
                else{
                
                    [AlterView AlterViewShowWithMesssge:@"账户或密码错误"];
                }
        ;
    } andFailBlock:^(NSError *error) {
        NSLog(@"登录请求失败%@",error);
        //请求成功 隐藏浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        //请求失败提示
        [AlterView AlterViewShowWithMesssge:@"网络请求错误"];
    }];
    
    
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        if ([responseObject[@"result"] isEqualToString:@"1"]) {
//            //单利传值
//            [MyDataCenter defaultcenter].infoStr=responseObject[@"entity"][@"JSESSIONID"];
//            
//            //验证通过跳转
//            MainViewController *mainVCl=[[MainViewController alloc] init];
//            [self.navigationController pushViewController:mainVCl animated:YES];
//            
//            //一次获得
//            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//                                NSLog(@"%@", cookie);
//            }
//            
//            //修改
//            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
////            [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
//            [cookieProperties setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
//            [cookieProperties setObject:responseObject[@"entity"][@"JSESSIONID"] forKey:NSHTTPCookieValue];
//            [cookieProperties setObject:@"120.24.228.254" forKey:NSHTTPCookieDomain];
//            //[cookieProperties setObject:@"cnrainbird.com" forKey:NSHTTPCookieOriginURL];
//            [cookieProperties setObject:@"/VMai/" forKey:NSHTTPCookiePath];
////            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//            [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:60*30] forKey:NSHTTPCookieExpires];
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//             NSLog(@"。。。。。。%@", cookie);
//            
//            //清空cookie
//            NSHTTPCookieStorage *cookieJar1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar1 cookies]];
//            for (id obj in _tmpArray) {
//                [cookieJar deleteCookie:obj];
//            }
//
//        };
//        
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"错误%@",error);
//    }];
}
//上传位置
-(void)gengxinWeizhiUrlWithUlrStr:(NSString *)urlStr{

    NSDictionary *WeizhiDic=@{@"city":@"广州市",@"area":@"白云区"};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    // 设置请求格式
    //        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlStr parameters:WeizhiDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseObjectStr=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       
        NSLog(@"位置上传网络请求成功.....:%@",responseObjectStr);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"位置上传网络请求失败%@",error);
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



//登录
- (IBAction)loginBtnClick:(id)sender {
    
    _str1=_textField1.text;
    _str2=_textfield2.text;
    
    //连接网络提示
    [AlterView showMBProgessHUDSuperView:self.view animate:YES];
        
    //上传数据
    [self requestDataWithUlrStr:loginUrl];
    
    /**************测试用************/
//    MainViewController *mainVCl=[[MainViewController alloc] init];
//    [self.navigationController pushViewController:mainVCl animated:YES];
}
//收回键盘
- (IBAction)TextFieldEnd:(id)sender {
    
    [_textField1 resignFirstResponder];
    [_textfield2 resignFirstResponder];
}
//忘记密码
- (IBAction)WangjiMiMaBtnClick:(id)sender {
    
    WangjiMiMaViewController *WangjiMiMaVCl=[[WangjiMiMaViewController alloc] init];
    [self.navigationController pushViewController:WangjiMiMaVCl animated:YES];
}

//注册
- (IBAction)registerBtnClick:(id)sender {
    
    registerViewController *registerVCl=[[registerViewController alloc] init];
    [self.navigationController pushViewController:registerVCl animated:YES];
}
@end
