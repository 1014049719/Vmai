//
//  PublicToolClass.h
//  工具类使用
//
//  Created by Demon_ZGY on 15/4/25.
//  Copyright (c) 2015年 Demon_ZGY. All rights reserved.
//

//公共工具类
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//成功回调
typedef void (^successBlcok)(id data);

//失败回调
typedef void (^failBlock)(NSError *error);

@interface PublicToolClass : NSObject

//类方法，打印一个字符串
//调用只需"类名+方法名"就OK了，此等做法的好处就是，不用实例化当前类对象，就可以调用其构造的方法
//因此，你可以把很多界面都需要调用的方法构造到这里面，要调用时候，只需引入此头文件就好了
+(void)PrintSomething:(NSString *)str;


/**
 @param urlStr：网址链接
 @param parDict:参数字典
 */
+(void)myDataRequestWithUrlString:(NSString *)urlStr andWithParameter:(NSDictionary *)parDict andSuccessBlock:(successBlcok)succAction andFailBlock:(failBlock)failAction;


@end
