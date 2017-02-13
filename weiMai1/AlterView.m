//
//  AlterView.m
//  XiangyaoWant
//
//  Created by 天宏 on 15-3-23.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "AlterView.h"
#import "MBProgressHUD.h"

@implementation AlterView

//事件提醒
+(void)AlterViewShowWithMesssge:(NSString *)messageStr{

    UIAlertView *alterView=[[UIAlertView alloc] initWithTitle:@"提示⚠️" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}
//显示网络提示
+ (void)showMBProgessHUDSuperView:(UIView *)superView animate:(BOOL)animate
{
    //提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:animate];
    //设置文字
    hud.labelText = @"正在加载...";
    //hud.detailsLabelText = @"请稍后";
}

//隐藏网络提示
+ (void)hideAllProgessHUDSuperView:(UIView *)superView animate:(BOOL)animate
{
    //隐藏
    [MBProgressHUD hideAllHUDsForView:superView animated:animate];
}
@end
