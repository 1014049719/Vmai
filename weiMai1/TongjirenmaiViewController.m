//
//  TongjirenmaiViewController.m
//  weiMai1
//
//  Created by 天宏 on 15-4-28.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "TongjirenmaiViewController.h"
#import <Masonry.h>
#import "renTableViewCell.h"
#import "MJRefresh.h"
#import "Model.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "AlterView.h"


#define jinriUrl @"http://120.24.228.254/VMai/user/getPushDetail"
#define touxiangUrl @"http://120.24.228.254/VMaiImages/head/"


@interface TongjirenmaiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //数据源
    NSMutableArray *_dataMutableArr;
    //页面
    int _page;
}
@end

@implementation TongjirenmaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataMutableArr=[[NSMutableArray alloc] init];
    _page=1;
    
    //显示网络状态
    [AlterView showMBProgessHUDSuperView:self.view animate:YES];
    
    //请求数据
    [self requestDatafromURLstr:[NSString stringWithFormat:jinriUrl]];

    
    [self.toubuLanseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view);
    }];
    [self.ToubuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(101, 24));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_toubuLanseView).offset(-3);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 42));
        make.left.equalTo(self.toubuLanseView).offset(8);
        make.bottom.equalTo(self.toubuLanseView).offset(-5);
    }];
    [self.tubiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 50));
        make.centerY.equalTo(self.ToubuLabel);
        make.right.equalTo(self.view).offset(-8);
        
    }];
    
    [self.sousuoBeijing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(248, 33));
        make.centerX.equalTo(self.view);
        make.top.equalTo(_toubuLanseView.mas_bottom).offset(19);
    }];
    [self.sousuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 22));
        make.centerY.equalTo(_sousuoBeijing);
        make.left.equalTo(_sousuoBeijing);
    }];
    [self.sousuoTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(165, 30));
        make.centerY.equalTo(_sousuoBeijing);
        make.left.equalTo(self.sousuoLabel.mas_right);
    }];
    [self.sousuoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 35));
        make.centerY.equalTo(_sousuoBeijing);
        make.left.equalTo(self.sousuoTextfield.mas_right);
    }];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        //        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.sousuoBeijing.mas_bottom).offset(8);
    }];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    //注册Xib
    [_tableView registerNib:[UINib nibWithNibName:@"renTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    //添加刷新头部、尾部视图
    [_tableView addHeaderWithTarget:self action:@selector(dealHead)];
    [_tableView addFooterWithTarget:self action:@selector(dealFoot)];
}
//刷新操作
-(void)dealHead{
    
    _page=1;
    [_dataMutableArr removeAllObjects];
    [self requestDatafromURLstr:[NSString stringWithFormat:jinriUrl]];
}
-(void)dealFoot{
    
    _page++;
    [self requestDatafromURLstr:[NSString stringWithFormat:jinriUrl]];
}

//请求数据
-(void)requestDatafromURLstr:(NSString *)urlString{
    
    NSDictionary *dic=@{@"type":@"1",@"pageNumber":[NSString stringWithFormat:@"%d",_page],@"pageSize":@"10",@"keyword":_sousuoTextfield.text};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:urlString parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //请求成功 隐藏浮框
        [AlterView hideAllProgessHUDSuperView:self.view animate:YES];
        
        NSLog(@"今日人脉获取成功%@",responseObject[@"page"][@"list"]);
        
        NSArray *jsonArr=responseObject[@"page"][@"list"];
        for (NSDictionary *dic in jsonArr) {
            Model *model=[[Model alloc] init];
            model.nickname=dic[@"nickname"];
            model.job=dic[@"job"];
            model.note=dic[@"note"];
            model.head=dic[@"head"];
            
            [_dataMutableArr addObject:model];
        }
        //刷新tableview。不然不显示
        [_tableView reloadData];
        
        //获取到数据后，停止刷新
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"今日人脉获取失败%@",error);
    }];
    
}


//返回多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
//每组多少列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataMutableArr.count;
}

//每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    renTableViewCell *Cell = (renTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return Cell.frame.size.height;
}
//显示cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"cell";
    renTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[renTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //一定要先判断数据源里面是否有数据，否则会崩溃
    if (_dataMutableArr.count>0) {
        Model *model=[_dataMutableArr objectAtIndex:indexPath.row];
        
        [cell.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",touxiangUrl,model.head]]];
        cell.nichengLabel.text=model.nickname;
        cell.zhiweiLabel.text=model.job;
        cell.beizhuLabel.text=model.note;
       
        //给cell上的button赋tag
        cell.faduanxinBtn.tag=indexPath.row;
        [cell.faduanxinBtn addTarget:self action:@selector(faduanxinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dadianhuaBtn.tag=indexPath.row;
        [cell.dadianhuaBtn addTarget:self action:@selector(dadianhuaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
//发短信
-(void)faduanxinBtnClick:(UIButton *)btn{
    
    //调用短信
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://466453"]];
    
    if (_dataMutableArr.count>0) {
        Model *model=[_dataMutableArr objectAtIndex:btn.tag];
        NSLog(@"发短信%ld",(long)btn.tag);
        
        NSString *phoneStr=model.phone;
        
        //调用短信
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneStr]]];
        
    }
}
//打电话
-(void)dadianhuaBtnClick:(UIButton *)btn{
    
    if (_dataMutableArr.count>0) {
        Model *model=[_dataMutableArr objectAtIndex:btn.tag];
        
        NSString *phoneStr=model.phone;
        
        //调用短信
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
        
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


//搜索
- (IBAction)sousuoBtnClick:(id)sender {
    
    //请求搜索数据
    //输入时开始搜索
    [_dataMutableArr removeAllObjects];
    [_tableView reloadData];
    //请求数据
    [self requestDatafromURLstr:[NSString stringWithFormat:jinriUrl]];
}

//返回
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
