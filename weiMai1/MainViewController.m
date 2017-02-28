//
//  MainViewController.m
//  WeiMai
//
//  Created by 天宏 on 15-4-23.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "MainViewController.h"
#import "xiuGaiViewController.h"
#import <AFNetworking.h>
#import <MapKit/MapKit.h>
#import <Masonry.h>
#import "AlterView.h"
#import "jinrirenmaiViewController.h"
#import "TongjirenmaiViewController.h"
#import "Model.h"
#import "AlterView.h"
#import "KKAreaPicker.h"
#import <UIImageView+AFNetworking.h>
#import <AddressBook/AddressBook.h>


#define gengxinMingpianUrl @"http://120.24.228.254/VMai/user/JsonEditUser"
#define gengxinTouxiangUrl @"http://120.24.228.254/VMai/user/uploadHead"
#define huoquRenmaiUrl @"http://120.24.228.254/VMai/user/getUserInfos"

#define huoquBierentongxunluUrl @"http://120.24.228.254/VMai/user/autoGetUserInfo"
#define huoquBenrentongxunluUrl @"http://120.24.228.254/VMai/user/downloadContacts"

#define SousuoshujuUrl @"http://120.24.228.254/VMai/user/getSeachType"

#define XiazaiTouxiangUrl @"http://120.24.228.254/VMaiImages/head/"
#define shangchuanTongxunluUrl @"http://120.24.228.254/VMai/user/uploadContacts"

@interface MainViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    //威霸正常模式开关
    BOOL isOpen;
    BOOL isOpen2;
    
    //搜索列表显示开关
    BOOL isSousuo;
    
    //master分支变更-----
    
    //提示框
    UIAlertView *_alterView;
    
    //更新名片
    NSString *_str1;
    NSString *_str2;
    NSString *_str3;
    NSString *_str4;
   
    NSData *data;
    UIImagePickerController * _picker;
    //图片2进制路径
    NSString* filePath;
    
    //保存人脉等级信息
    NSString *_levelStr;
    NSString *_todayStr;
    NSString *_allStr;
    
    //获取后台通讯录数据源
    NSMutableArray *_DataArr1;
    //恢复本人通讯录数据源
    NSMutableArray *_DataArr2;
    
    //缓存 持久化
    NSUserDefaults *_userDefault;
    //开关状态数字
    int _a;
    
    //搜索结果列表
    UITableView *_tableView;
    //搜索数据源
    NSMutableArray *_dataMutableArr;
    
    //最终拼接好的通讯录字符串
    NSMutableString *_mutableStr;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据源
    _dataMutableArr=[[NSMutableArray alloc] init];
    
    //登陆界面传值用户信息
    _nichengTextField.text=_nicknameStr;
    _zhiyeTextField.text=_jobStr;
    _beizhuTextField.text=_noteStr;
    
    //设置传值头像
    [self.touxiangImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",XiazaiTouxiangUrl,_TouxiangnameStr]]];
    //给头像图片添加点击手势
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImage:)];
    [self.touxiangImageView addGestureRecognizer:tapGesture];
    
    _userDefault=[NSUserDefaults standardUserDefaults];
    
    _a=[_userDefault boolForKey:@"MoshiKaiguan"];
    
    isSousuo=NO;
    
    //监听是否搜索框在输入
    [self.textFieldshang3 addTarget:self
                             action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
    
    //若果有缓存 且威霸模式打开
    if (_a==1) {
        
        //威霸
        isOpen2=YES;
        //正常模式
        isOpen=NO;
        
        //设为微霸模式当前最大
        CGRect frame1=_weibaBtn.frame;
        CGRect frmae2=_zhengchangBtn.frame;
        _zhengchangBtn.frame=frame1;
        _weibaBtn.frame=frmae2;
        [_weibaBtn setBackgroundImage:[UIImage imageNamed:@"圆片红.png"] forState:UIControlStateNormal];
        [_zhengchangBtn setBackgroundImage:[UIImage imageNamed:@"圆片灰.png"] forState:UIControlStateNormal];
//        [_zhongjianmoshiBeijing bringSubviewToFront:_weibaBtn];

        //威霸时搜索框和按扭 可使用
        [_sousuoBtn setEnabled:YES];
        [_textFieldshang3 setEnabled:YES];
    }
    else{
    
        //正常模式
        isOpen=YES;
        //威霸
        isOpen2=NO;
        
        //正常时搜索框和按扭 禁用
        [_sousuoBtn setEnabled:NO];
        [_textFieldshang3 setEnabled:NO];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _DataArr1=[[NSMutableArray alloc] init];
    _DataArr2=[[NSMutableArray alloc] init];
    
    _alterView.delegate=self;
    
    _picker = [[UIImagePickerController alloc]init];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    
    //搜索代理
    _textFieldshang3.delegate=self;
    
    //界面布局
    [self.lanseBeijingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        if([UIScreen mainScreen].bounds.size.height>=667){
            make.height.mas_equalTo(@280);
        }
        else{
            make.height.mas_equalTo(@220);
        }
    }];
    [self.shezhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(70, 43));
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
   
    [self.bk3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(38);
        make.right.equalTo(self.view).offset(-38);
        if ([UIScreen mainScreen].bounds.size.height>=736) {
            make.height.mas_equalTo(40);
        }
        else{
            make.height.mas_equalTo(33);
        }
        make.bottom.equalTo(_lanseBeijingView).offset(-10);
    }];
    [self.bk1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_bk3);
        make.bottom.equalTo(_bk3.mas_top).offset(-8);
        make.left.equalTo(_bk3);
        make.right.equalTo(self.view.mas_centerX).offset(-5);
    }];
    [self.bk2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_bk3);
        make.centerY.equalTo(_bk1);
        make.right.equalTo(_bk3);
        make.left.equalTo(self.view.mas_centerX).offset(5);
    }];
    [self.chengshiLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(37, 21));
        make.centerY.equalTo(_bk1);
        make.left.equalTo(_bk1).offset(4);
    }];
    [self.quyiLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(41, 21));
        make.centerY.equalTo(_bk2);
        make.left.equalTo(_bk2).offset(4);
    }];
    [self.sousuoLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 22));
        make.centerY.equalTo(_bk3);
        make.left.equalTo(_bk3).offset(4);
    }];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chengshiLabel1.mas_right).offset(3);
        make.height.equalTo(_bk1);
        make.centerY.equalTo(_bk1);
        make.right.equalTo(_bk1);
    }];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_quyiLabel2.mas_right).offset(3);
        make.height.equalTo(_bk2);
        make.centerY.equalTo(_bk2);
        make.right.equalTo(_bk2);
    }];
    [self.textFieldshang3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sousuoLabel3.mas_right).offset(3);
        make.height.equalTo(_bk3);
        make.centerY.equalTo(_bk3);
        make.right.equalTo(_sousuoBtn.mas_left).offset(5);
    }];
    [self.sousuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 35));
        make.centerY.equalTo(_bk3);
        make.right.equalTo(_bk3);
    }];
    [self.chengshiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_bk1);
        make.center.equalTo(_bk1);
    }];
    [self.quyuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_bk2);
        make.center.equalTo(_bk2);
    }];
    
    
    [self.mingpianBeijingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_bk3);
        make.height.mas_equalTo(81);
        make.centerX.equalTo(self.view);
        if ([UIScreen mainScreen].bounds.size.height<=568) {
            make.top.equalTo(self.view).offset(50);
        }
        else {
            make.top.equalTo(self.view).offset(70);
        }
    }];
    [self.gerenmingpianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 21));
        make.left.equalTo(_mingpianBeijingView);
        make.bottom.equalTo(_mingpianBeijingView.mas_top);
    }];
    
    [self.dengjiBeijingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        if ([UIScreen mainScreen].bounds.size.height<=480) {
            make.top.equalTo(self.lanseBeijingView.mas_bottom).offset(10);
        }
        else{
            make.top.equalTo(self.lanseBeijingView.mas_bottom).offset(30);
        }
        make.centerX.equalTo(self.view);
    }];
    
    [_zhengchangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if([UIScreen mainScreen].bounds.size.height>=667){
            make.size.mas_equalTo(CGSizeMake(120, 120));
            make.top.equalTo(self.dengjiBeijingView.mas_bottom).offset(110);
            make.right.equalTo(self.view.mas_centerX).offset(-15);
        }
        else {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.top.equalTo(self.dengjiBeijingView.mas_bottom).offset(60);
            make.right.equalTo(self.view.mas_centerX).offset(-15);
        }
    }];
    [_weibaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_zhengchangBtn);
        make.centerY.equalTo(_zhengchangBtn);
        make.left.equalTo(self.view.mas_centerX).offset(15);
    }];
    
    [self.yihuoqurenmaiLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 21));
        make.centerX.equalTo(self.view);
        if ([UIScreen mainScreen].bounds.size.height<=480) {
            make.bottom.equalTo(self.view).offset(-35);
        }
        else{
            make.bottom.equalTo(self.view).offset(-50);
        }
    }];
    [self.yihuoqurenmailabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.yihuoqurenmaiLabel2);
        make.bottom.equalTo(self.yihuoqurenmaiLabel2.mas_top).offset(-5);
        make.centerX.equalTo(self.yihuoqurenmaiLabel2);
    }];
    [self.tongjiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 21));
        make.centerY.equalTo(self.yihuoqurenmaiLabel2);
        make.right.equalTo(self.yihuoqurenmaiLabel2.mas_left).offset(-3);
    }];
    [self.jinriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.tongjiLabel);
        make.centerY.equalTo(self.yihuoqurenmailabel1);
        make.centerX.equalTo(self.tongjiLabel);
    }];
    [self.tongjishuziBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 21));
        make.centerY.equalTo(self.yihuoqurenmaiLabel2);
        make.left.equalTo(self.yihuoqurenmaiLabel2.mas_right).offset(3);
    }];
    [self.jinrishuziBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_tongjishuziBtn);
        make.centerY.equalTo(self.yihuoqurenmailabel1);
        make.left.equalTo(self.yihuoqurenmailabel1.mas_right).offset(3);
    }];
    
    [self.xiafanggongsiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(165, 21));
        make.bottom.equalTo(self.view).offset(-5);
        make.centerX.equalTo(self.view).offset(-23);
    }];
    [self.banbenshuomingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(46, 30));
        make.centerY.equalTo(self.xiafanggongsiLabel);
        make.left.equalTo(self.xiafanggongsiLabel.mas_right).offset(3);
    }];
    
    //获取人脉信息
    [self huoquRenmaiWithUlrStr:huoquRenmaiUrl];
}
//获取人脉信息
-(void)huoquRenmaiWithUlrStr:(NSString *)urlString{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
        [_jinrishuziBtn setTitle:responseObject[@"entity"][0][@"downcount_today"] forState:UIControlStateNormal];
        [_tongjishuziBtn setTitle:responseObject[@"entity"][0][@"downcount_all"] forState:UIControlStateNormal];
        
        int a=[responseObject[@"entity"][0][@"level"] intValue];
        NSLog(@"等级。。。。。。。。。。。。。。。。。。。。。。%d",a);
        NSLog(@"获取人脉信息成功 %d", a);
        switch (a) {
            case 2:{
                _vipView1.highlighted=YES;
                _vipView2.highlighted=YES;
                
                [UIView animateWithDuration:2 animations:^{
                    CGRect frame=_zhongjianView.frame;
                    frame.size.width=a*45;
                    _zhongjianView.frame=frame;
                    
                    NSLog(@"长度.................%f",frame.size.width);
                    NSLog(@"等级。。。。。。。。。。。。。。。。。。。。。。%d",a);
                }];
            }
                break;
            case 3:{
                _vipView1.highlighted=YES;
                _vipView2.highlighted=YES;
                _vipView3.highlighted=YES;
                
                [UIView animateWithDuration:2 animations:^{
                    CGRect frame=_zhongjianView.frame;
                    frame.size.width=a*45;
                    _zhongjianView.frame=frame;
                    
                    NSLog(@"长度.................%f",frame.size.width);
                    NSLog(@"等级。。。。。。。。。。。。。。。。。。。。。。%d",a);
                }];

            }
                break;
            case 4:{
                _vipView1.highlighted=YES;
                _vipView2.highlighted=YES;
                _vipView3.highlighted=YES;
                _vipView4.highlighted=YES;
                
                [UIView animateWithDuration:2 animations:^{
                    CGRect frame=_zhongjianView.frame;
                    frame.size.width=a*45;
                    _zhongjianView.frame=frame;
                    
                    NSLog(@"长度.................%f",frame.size.width);
                    NSLog(@"等级。。。。。。。。。。。。。。。。。。。。。。%d",a);
                }];
            }
                break;
            case 5:{
                _vipView1.highlighted=YES;
                _vipView2.highlighted=YES;
                _vipView3.highlighted=YES;
                _vipView4.highlighted=YES;
                _vipView5.highlighted=YES;
                
                [UIView animateWithDuration:2 animations:^{
                    CGRect frame=_zhongjianView.frame;
                    frame.size.width=a*45;
                    _zhongjianView.frame=frame;
                    
                    NSLog(@"长度.................%f",frame.size.width);
                    NSLog(@"等级。。。。。。。。。。。。。。。。。。。。。。%d",a);
                }];
            }
                break;
            default:
                break;
        }
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取人脉信息失败 %@", error.localizedDescription);
    }];
}

//点击搜索输入框
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    _tableView.hidden=NO;
    if (isSousuo==NO) {
        NSLog(@"准备开始输入");
        //创建结果搜索列表
        [self creatSousuoJieguoView];
        
        isSousuo=YES;
    }
    
    return YES;
}
//正在输入
-(void)textFieldDidChange:(id)sender
{
    
    _tableView.hidden=NO;
    
    //再次输入时先清空列表
    [_dataMutableArr removeAllObjects];
    [_tableView reloadData];
    
    //输入时开始搜索
        [self requestDatafromURLstr:[NSString stringWithFormat:SousuoshujuUrl]];
}

//请求搜索数据
-(void)requestDatafromURLstr:(NSString *)urlString{
    
    NSDictionary *dic=@{@"PriKey":_textFieldshang3.text};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:urlString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"搜索数据成功%@",responseObject);
        NSArray *jsonArr=responseObject[@"entity"];
        for (NSDictionary *dic in jsonArr) {
            NSLog(@"%@",dic[@"category"]);
            
            [_dataMutableArr addObject:dic[@"category"]];
        }
        
        //刷新tableview。不然不显示
        [_tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"搜索数据成功失败%@",error);
    }];
    
}

//创建结果搜索列表
-(void)creatSousuoJieguoView{

    _tableView=[[UITableView alloc] init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bk3);
        make.top.equalTo(_bk3.mas_bottom);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@200);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataMutableArr.count;
}

//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}
//显示cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //一定要先判断数据源里面是否有数据，否则会崩溃
    if (_dataMutableArr.count>0) {
        
        cell.contentView.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        cell.textLabel.text=_dataMutableArr[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    _textFieldshang3.text=_dataMutableArr[indexPath.row];
}

//更新名片上传数据
-(void)requestDataWithUlrStr:(NSString *)urlString{
    
    NSDictionary *dic=@{@"nickname":_str1,@"job":_str2,@"note":_str3};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //请求成功 隐藏浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"更新名片成功 %@", result);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"更新名片错误 %@", error.localizedDescription);
    }];
}

//更新头像
-(void)uploadTouxiangWithUlrStr:(NSString *)urlString{
    
    NSDictionary *dic=@{@"filename":@"image"};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"multipart/form-data",nil];
    // 设置请求格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
//        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:@"image" error:NULL];
        
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:@"image" fileName:@"image" mimeType:@"image/jpg" error:NULL];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"头像上传请求成功 %@", result);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"头像上传请求错误 %@", error.localizedDescription);
    }];
    
}
#pragma mark    ---------获取通讯录内容------------
-(NSMutableDictionary*)getPersonInfo{
    
    
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayDic = [NSMutableArray arrayWithCapacity:0];
    //取得本地通信录名柄
    ABAddressBookRef addressBook ;
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)                                                 {                                                     dispatch_semaphore_signal(sema);                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        addressBook = ABAddressBookCreate();
    }
    
    
    //取得本地所有联系人记录
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //    NSLog(@"-----%d",(int)CFArrayGetCount(results));
    //        NSLog(@"in %s %d",__func__,__LINE__);
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionaryWithCapacity:0];
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
        NSString *first = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (first==nil) {
            first = @" ";
        }
        [dicInfoLocal setObject:first forKey:@"first"];
        
        NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (last == nil) {
            last = @" ";
        }
        [dicInfoLocal setObject:last forKey:@"last"];
        
        
        
        
        ABMultiValueRef tmlphone =  ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString* telphone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmlphone, 0);
        if (telphone == nil) {
            telphone = @" ";
        }
        [dicInfoLocal setObject:telphone forKey:@"telphone"];
        
        CFRelease(tmlphone);
        
        [self.dataArrayDic addObject:dicInfoLocal];
        
    }
    
    NSLog(@"联系人字典 %@",self.dataArrayDic);
    
    CFRelease(results);//new
    CFRelease(addressBook);//new
    
    //排序
    //建立一个字典，字典保存key是A-Z  值是数组
    NSMutableDictionary*index=[NSMutableDictionary dictionaryWithCapacity:0];
    
    _mutableStr=[[NSMutableString alloc] init];
    for (NSDictionary*dic in self.dataArrayDic) {
        
        NSString* str2=[dic objectForKey:@"last"];
        NSLog(@"姓氏 ：%@",str2);
        
        NSString* str=[dic objectForKey:@"first"];
        NSLog(@"名 ：%@",str);
        
        NSString* str3=[dic objectForKey:@"telphone"];
        NSLog(@"电话 ：%@",str3);
        
        //拼接上传字符串
        NSString* shangchuanStr=[NSString stringWithFormat:@"%@%@,%@;",str2,str,str3];
        NSLog(@"拼接上传字符串 ：%@",shangchuanStr);
        
        //        NSLog(@"%@",dic);
        [_mutableStr appendString:shangchuanStr];
    }
    NSLog(@"最终上传字符串%@",_mutableStr);
    
    //上传数据
    [self shangchuanbendiTongxunluWithUlrStr:shangchuanTongxunluUrl];
    
    return index;
}
//请求上传通讯录
//上传数据
-(void)shangchuanbendiTongxunluWithUlrStr:(NSString *)urlString{
    
    //    NSDictionary *dic=@{@"contacts":@"wthh,18579186942;wwww,18579186942;"};
    
    NSDictionary *dic=@{@"contacts":_mutableStr};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    // 设置请求格式
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseObjectStr=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"通讯录上传成功.....:%@",responseObjectStr);
        
        if ([responseObjectStr isEqualToString:@"已上传完成"]) {
            NSLog(@"可以开始删除本地通讯录");
            //上传成功开始清空本地
            [self clearAddressDataWeibamoshi];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"通讯录上传失败%@",error);
    }];
    
}

#pragma mark 微霸模式 上传成功后后  -- 通讯录 清除  数据 （清空本地数据）
-(void)clearAddressDataWeibamoshi{
    
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // 遍历所有的联系人并删除
        for (id obj in array) {
            ABRecordRef people = (__bridge ABRecordRef)obj;
            ABAddressBookRemoveRecord(addressBook, people, NULL);
        }
        // 保存修改的通讯录对象
        ABAddressBookSave(addressBook, NULL);
        // 释放通讯录对象的内存
        if (addressBook) {
            CFRelease(addressBook);
        }
       });
    //清空成功 隐藏浮框
    [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
}

//获取网络别人通讯录数据 添加到本地
-(void)huoquBierentongxunluWithUlrStr:(NSString *)urlString{
    
    NSDictionary *dic=@{@"city":_cityLabel.text,@"area":_areaLabel.text,@"type":_textFieldshang3.text};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];    // 设置请求格式
    [manager POST:urlString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
       
        //请求成功 隐藏浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        
        //如果成功就开始添加别人数据到本地
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
        
            NSLog(@"获取后台别人通讯录成功 %@", responseObject[@"entity"]);
        NSArray *jsonArray=responseObject[@"entity"];
            
            //从数组中遍历添加到本地
            for (NSDictionary *jsonDic in jsonArray) {
            
            //添加别人通讯录到本地
                
                [self addContactName:jsonDic[@"username"] phoneNum:jsonDic[@"phone"] withLabel:jsonDic[@"note"]];
                
                //添加成功后给缓存赋值，记录威霸模式打开
                [_userDefault setBool:YES forKey:@"MoshiKaiguan"];
                [_userDefault synchronize];
                NSLog(@"开关状态 ：%d",[_userDefault boolForKey:@"MoshiKaiguan"]);
           }
            
            //下载完别人后，同时更新人脉数量信息
            [self huoquRenmaiWithUlrStr:huoquRenmaiUrl];
            
    }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取后台别人通讯录失败 %@", error.localizedDescription);
    }];
}


#pragma mark  恢复正常模式模式  -- 通讯录 清除  数据 （清空本地数据）
-(void)clearAddressDataZhengchangmoshi{
    
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // 遍历所有的联系人并删除
        for (id obj in array) {
            ABRecordRef people = (__bridge ABRecordRef)obj;
            ABAddressBookRemoveRecord(addressBook, people, NULL);
        }
        // 保存修改的通讯录对象
        ABAddressBookSave(addressBook, NULL);
        // 释放通讯录对象的内存
        if (addressBook) {
            CFRelease(addressBook);
        }
    });
    
    //清空本地通讯录后 请求个人备份通讯录并添加到本地
    [self huoquBenrentongxunluWithUlrStr:huoquBenrentongxunluUrl];
}

//获取自己备份通讯录数据 添加到本地
-(void)huoquBenrentongxunluWithUlrStr:(NSString *)urlString{
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];    // 设置请求格式
    [manager POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        //如果成功就开始添加别人数据到本地
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
            
            NSLog(@"获取后台自己通讯录成功 %@", responseObject[@"entity"]);
            NSArray *jsonArray=responseObject[@"entity"];
            
            //从数组中遍历添加到本地
            for (NSDictionary *jsonDic in jsonArray) {
                
                //添加别人通讯录到本地
                
                [self addContactName:jsonDic[@"name"] phoneNum:jsonDic[@"phone"] withLabel:@""];
            }
            //请求成功 隐藏浮框
            [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
            
            //添加成功后给缓存赋值，记录威霸模式关闭
            [_userDefault setBool:NO forKey:@"MoshiKaiguan"];
            [_userDefault synchronize];
            NSLog(@"开关状态 ：%d",[_userDefault boolForKey:@"MoshiKaiguan"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取后台自己通讯录失败 %@", error.localizedDescription);
    }];
}
#pragma  mark 添加联系人
// 添加联系人（联系人名称、号码、号码备注标签）
- (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num withLabel:(NSString*)label{
    // 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();    CFErrorRef error;
    // 设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)num, (__bridge CFTypeRef)label, NULL);    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    ABAddressBookRef addressBook = nil;
    // 如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)    {        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)                                                 {                                                     dispatch_semaphore_signal(sema);                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        addressBook = ABAddressBookCreate();
    }
    // 将新建联系人记录添加如通讯录中
    BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
    if (!success) {
        return NO;
    }else{
        // 如果添加记录成功，保存更新到通讯录数据库中
        success = ABAddressBookSave(addressBook, &error);        return success ? YES : NO;
    }
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

//搜索事件
- (IBAction)SousuoBtnClick:(id)sender {
    
    //显示进度提示
    [AlterView showMBProgessHUDSuperView:self.view animate:YES];
    //请求数据下载别人通讯录并添加到本地
    [self huoquBierentongxunluWithUlrStr:huoquBierentongxunluUrl];
    
    _tableView.hidden=YES;
    
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(QingqiubierenTongxunlu) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)QingqiubierenTongxunlu{

    static int i=700;
    i--;
    if (i<=0) {
        i=700;
        //定时调用
        //请求数据下载别人通讯录并添加到本地
        [self huoquBierentongxunluWithUlrStr:huoquBierentongxunluUrl];
        
        return;
    }
    NSLog(@"%d",i);
    return;
}

//点击名头头像
- (void)tapHeadImage:(id)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自图库",@"拍照", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_picker animated:YES completion:^{
            ;
        }];
    }
    
    if (buttonIndex == 1)
    {
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_picker animated:YES completion:^{
            ;
        }];
    }
    
}
//选择图片 后保存
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage * image = info[UIImagePickerControllerEditedImage];
    NSData * data2 = UIImagePNGRepresentation(image);
    data = data2;
    self.touxiangImageView.image=image;
    
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    NSLog(@"%@",filePath);
    
    //上传图片
    [self uploadTouxiangWithUlrStr:gengxinTouxiangUrl];

    
    
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

//退出键盘
- (IBAction)textFieldEnd:(id)sender {
    
    [_textFieldshang3 resignFirstResponder];
    [_nichengTextField resignFirstResponder];
    [_zhiyeTextField resignFirstResponder];
    [_beizhuTextField resignFirstResponder];

    //隐藏搜索
    _tableView.hidden=YES;
}
//修改资料
- (IBAction)xiuGaiBtnClick:(id)sender {
    
    xiuGaiViewController *xiugaiVCl=[[xiuGaiViewController alloc] init];
    [self.navigationController pushViewController:xiugaiVCl animated:YES];
}

//更新名片
- (IBAction)GengxinMingpianBtnClick:(id)sender {
    
    _str1=_nichengTextField.text;
    _str2=_zhiyeTextField.text;
    _str3=_beizhuTextField.text;

    //显示网络提示
    [AlterView showMBProgessHUDSuperView:self.view animate:YES];
    //上传数据
    [self requestDataWithUlrStr:gengxinMingpianUrl];
}

//微霸
- (IBAction)weibaBtnClick:(id)sender {
    
    
    if (isOpen2==NO) {
        
        //弹出提示框
        UIAlertView *alterView=[[UIAlertView alloc] initWithTitle:@"提示⚠️" message:@"即将进入微霸模式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    //点击确定 进入微霸模式
    if (buttonIndex==1) {
        
        CGRect frame1=_weibaBtn.frame;
        CGRect frmae2=_zhengchangBtn.frame;
        
        [UIView animateWithDuration:0.5 animations:^{
            _zhengchangBtn.frame=frame1;
            _weibaBtn.frame=frmae2;
        } completion:^(BOOL finished) {
            NSLog(@"开启威霸模式");
        }];
        
        [_weibaBtn setBackgroundImage:[UIImage imageNamed:@"圆片红.png"] forState:UIControlStateNormal];
        [_zhengchangBtn setBackgroundImage:[UIImage imageNamed:@"圆片灰.png"] forState:UIControlStateNormal];
        
//        [_zhongjianmoshiBeijing bringSubviewToFront:_weibaBtn];
        
        isOpen2=YES;
        isOpen=NO;
        
        //威霸时搜索框和按扭 可以使用
        [_sousuoBtn setEnabled:YES];
        [_textFieldshang3 setEnabled:YES];
       
        //显示进度提示
        [AlterView showMBProgessHUDSuperView:self.view animate:YES];
        
        //开启微霸模式 就获得本地所有联系人并未且上传
        [self getPersonInfo];
        
        
    }
    
}

//正常
- (IBAction)zhengchangBtnClick:(id)sender {
    
    
    CGRect frame1=_weibaBtn.frame;
    CGRect frmae2=_zhengchangBtn.frame;
    
    if (isOpen==NO) {
        [UIView animateWithDuration:0.5 animations:^{
            _zhengchangBtn.frame=frame1;
            _weibaBtn.frame=frmae2;
            
            
            [_weibaBtn setBackgroundImage:[UIImage imageNamed:@"圆片灰.png"] forState:UIControlStateNormal];
            [_zhengchangBtn setBackgroundImage:[UIImage imageNamed:@"圆片蓝.png"] forState:UIControlStateNormal];
            
            
            isOpen=YES;
            isOpen2=NO;
            
//            [_zhongjianmoshiBeijing bringSubviewToFront:_zhengchangBtn];
            
            //显示进度提示
            [AlterView showMBProgessHUDSuperView:self.view animate:YES];
            //正常式后清空本地通讯录
            [self clearAddressDataZhengchangmoshi];
            
        } completion:^(BOOL finished) {
            NSLog(@"开启正常模式");
        }];
    }
    
}
//今日人脉
- (IBAction)jinriRenmaiBtnClick:(id)sender {
    
    jinrirenmaiViewController *jinriVCl=[[jinrirenmaiViewController alloc] init];
    [self.navigationController pushViewController:jinriVCl animated:YES];
}

//统计人脉
- (IBAction)tongjiRenmaiBtnClick:(id)sender {
    
    TongjirenmaiViewController *tongjiVCl=[[TongjirenmaiViewController alloc] init];
    [self.navigationController pushViewController:tongjiVCl animated:YES];
}

//版本说明
- (IBAction)banbenshuomingBtnClick:(id)sender {
    
}
//选择城市
- (IBAction)xuanzeCityBtn:(id)sender {
    
    KKAdrress *address=[[KKAdrress alloc] init];
    
    address.provice=@"广东";
    address.city=@"广州";
    address.area=@"天河区";
    
    [KKAreaPicker showPickerWithTitle:@"省市区选择" pickerType:KKAreaPickerTypeProviceCityArea defaultValue:address onCancel:^(KKAreaPicker *picker) {
        ;
    } onCommit:^(KKAreaPicker *picker, KKAdrress *address) {

        _cityLabel.text=address.city;
        _areaLabel.text=address.area;
        
        NSLog(@"选中:%@，%@，%@",address.provice,address.city,address.area);
    }];

}

@end
