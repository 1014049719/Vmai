//
//  AlterView.h
//  XiangyaoWant
//
//  Created by 天宏 on 15-3-23.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlterView : NSObject<UIAlertViewDelegate>

//弹出提示框
+(void)AlterViewShowWithMesssge:(NSString *)messageStr;

//显示网络提示
+ (void)showMBProgessHUDSuperView:(UIView *)superView animate:(BOOL)animate;
//隐藏网络提示
+ (void)hideAllProgessHUDSuperView:(UIView *)superView animate:(BOOL)animate;
@end
