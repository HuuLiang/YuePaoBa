//
//  YPBTableViewCell.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/23.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBTableViewCell : UITableViewCell

@property (nonatomic,retain,readonly) UIImageView *iconImageView;
@property (nonatomic,retain,readonly) UILabel *titleLabel;
@property (nonatomic,retain,readonly) UILabel *subtitleLabel;
@property (nonatomic,retain,readonly) UIImageView *backgroundImageView;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;

@end
