//
//  AppDelegate.m
//  weiMai1
//
//  Created by 天宏 on 15-4-24.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <SMS_SDK/SMS_SDK.h>


@interface AppDelegate ()
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    //短信验证
    [SMS_SDK registerApp:@"7230dfa043c6" withSecret:@"599aa9c5c9025d33b5ee8bd07d453c5c"];
    
    //地图授权
    _mapManager = [[BMKMapManager alloc]init];
    //    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"7G68Mc817vKERNvs93o03AWN"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图授权失败!");
    }
    
    LoginViewController *loginVcl=[[LoginViewController alloc] init];
    UINavigationController *nvc=[[UINavigationController alloc] initWithRootViewController:loginVcl];
    nvc.navigationBar.hidden=YES;
    self.window.rootViewController=nvc;
    
    //模拟启动画面 闪屏
    UIImageView *startView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    if ([UIScreen mainScreen].bounds.size.height<=480) {
        
        startView.image = [UIImage imageNamed:@"v8闪屏-小.png"];
    }
    else{
        startView.image = [UIImage imageNamed:@"v8闪屏.png"];
    }
    [nvc.view addSubview:startView];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:3.0];
    startView.alpha = 0;
    [UIView commitAnimations];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
