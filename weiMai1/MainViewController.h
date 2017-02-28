//
//  MainViewController.h
//  WeiMai
//
//  Created by 天宏 on 15-4-23.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

//develop更新--------

//保存排序好的数组index
@property(nonatomic,retain)NSMutableArray*dataArray;
//数组里面保存每个获取Vcard（名片）
@property(nonatomic,retain)NSMutableArray*dataArrayDic;

//登陆后传值
@property(strong,nonatomic)NSString *nicknameStr;
@property(strong,nonatomic)NSString *jobStr;
@property(strong,nonatomic)NSString *noteStr;
@property(strong,nonatomic)NSString *TouxiangnameStr;


@property (strong, nonatomic) IBOutlet UIControl *lanseBeijingView;
@property (strong, nonatomic) IBOutlet UIButton *shezhiBtn;
@property (strong, nonatomic) IBOutlet UIImageView *bk1;
@property (strong, nonatomic) IBOutlet UIImageView *bk2;
@property (strong, nonatomic) IBOutlet UIImageView *bk3;
@property (strong, nonatomic) IBOutlet UILabel *chengshiLabel1;
@property (strong, nonatomic) IBOutlet UILabel *quyiLabel2;
@property (strong, nonatomic) IBOutlet UILabel *sousuoLabel3;
@property (strong, nonatomic) IBOutlet UIButton *chengshiBtn;
@property (strong, nonatomic) IBOutlet UIButton *quyuBtn;

- (IBAction)xuanzeCityBtn:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UITextField *textFieldshang3;
@property (strong, nonatomic) IBOutlet UIButton *sousuoBtn;

@property (strong, nonatomic) IBOutlet UIView *mingpianBeijingView;
@property (strong, nonatomic) IBOutlet UIView *touxiangBeijing;
@property (strong, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (strong, nonatomic) IBOutlet UILabel *nichengLabel;
@property (strong, nonatomic) IBOutlet UILabel *zhiyeLabel;
@property (strong, nonatomic) IBOutlet UILabel *beizhuLabel;
@property (strong, nonatomic) IBOutlet UITextField *nichengTextField;
@property (strong, nonatomic) IBOutlet UITextField *zhiyeTextField;
@property (strong, nonatomic) IBOutlet UITextField *beizhuTextField;
@property (strong, nonatomic) IBOutlet UIButton *gengxinBtn;
@property (strong, nonatomic) IBOutlet UILabel *gerenmingpianLabel;
@property (strong, nonatomic) IBOutlet UIView *dengjiBeijingView;


- (IBAction)textFieldEnd:(id)sender;


//中间进度
@property (strong, nonatomic) IBOutlet UIImageView *zhongjianView;
//下方vip
@property (strong, nonatomic) IBOutlet UIImageView *vipView1;
@property (strong, nonatomic) IBOutlet UIImageView *vipView2;
@property (strong, nonatomic) IBOutlet UIImageView *vipView3;
@property (strong, nonatomic) IBOutlet UIImageView *vipView4;
@property (strong, nonatomic) IBOutlet UIImageView *vipView5;


//威霸  正常
@property (strong, nonatomic) IBOutlet UIButton *weibaBtn;
@property (strong, nonatomic) IBOutlet UIButton *zhengchangBtn;
- (IBAction)weibaBtnClick:(id)sender;
- (IBAction)zhengchangBtnClick:(id)sender;

//修改
- (IBAction)xiuGaiBtnClick:(id)sender;
//更新名片
- (IBAction)GengxinMingpianBtnClick:(id)sender;


//搜索事件
- (IBAction)SousuoBtnClick:(id)sender;



//今日和统计人脉事件
- (IBAction)jinriRenmaiBtnClick:(id)sender;
- (IBAction)tongjiRenmaiBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *jinriLabel;
@property (strong, nonatomic) IBOutlet UILabel *yihuoqurenmailabel1;
@property (strong, nonatomic) IBOutlet UIButton *jinrishuziBtn;
@property (strong, nonatomic) IBOutlet UIButton *tongjishuziBtn;
@property (strong, nonatomic) IBOutlet UILabel *tongjiLabel;
@property (strong, nonatomic) IBOutlet UILabel *yihuoqurenmaiLabel2;

@property (strong, nonatomic) IBOutlet UILabel *xiafanggongsiLabel;
@property (strong, nonatomic) IBOutlet UIButton *banbenshuomingBtn;
- (IBAction)banbenshuomingBtnClick:(id)sender;

@end
