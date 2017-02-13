//
//  PublicToolClass.m
//  工具类使用
//
//  Created by Demon_ZGY on 15/4/25.
//  Copyright (c) 2015年 Demon_ZGY. All rights reserved.
//

#import "PublicToolClass.h"

@implementation PublicToolClass


+(void)PrintSomething:(NSString *)str
{
    NSLog(@"我是要被打印的字符串String = %@",str);
}


+(void)myDataRequestWithUrlString:(NSString *)urlStr andWithParameter:(NSDictionary *)parDict andSuccessBlock:(successBlcok)succAction andFailBlock:(failBlock)failAction
{
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];

    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        [manager GET:urlStr parameters:parDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            if (succAction) {
                succAction(responseObject);
            }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failAction) {
            failAction(error);
            NSLog ( @"operation: %@" , operation.responseString );

        }
    
    }];

    
}

@end
