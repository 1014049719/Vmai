//
//  MyDataCenter.m
//  weiMai1
//
//  Created by 天宏 on 15-4-24.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import "MyDataCenter.h"

static MyDataCenter *mycenter=nil;

@implementation MyDataCenter

+(MyDataCenter *)defaultcenter{

    if (mycenter==nil) {
        mycenter=[[MyDataCenter alloc] init];
    }
    
    return mycenter;
}

@end
