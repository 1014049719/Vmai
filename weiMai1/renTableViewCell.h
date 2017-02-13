//
//  renTableViewCell.h
//  weiMai1
//
//  Created by 天宏 on 15-4-28.
//  Copyright (c) 2015年 天宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface renTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nichengLabel;
@property (strong, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (strong, nonatomic) IBOutlet UILabel *beizhuLabel;

@property (strong, nonatomic) IBOutlet UIButton *faduanxinBtn;
@property (strong, nonatomic) IBOutlet UIButton *dadianhuaBtn;


@end
