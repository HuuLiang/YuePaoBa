//
//  YPBRobotTableViewCell.h
//  YuePaoBa
//
//  Created by Liang on 16/5/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPBTableViewCell.h"


@interface YPBRobotTableViewCell : UITableViewCell

@property (nonatomic) UIView *bgView;

@property (nonatomic) UIImageView *image;

@property (nonatomic) YPBTableViewCell *editCell;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)layoutWelcomeSubviewsWithInfo:(NSString *)imageUrl;

- (void)layoutGreetSubviewsWithInfo:(NSString *)imageUrl count:(NSString *)count;

@property (nonatomic) YPBTableViewCell *greetCell;

@end
