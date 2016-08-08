//
//  YPBWinnerView.h
//  YuePaoBa
//
//  Created by Liang on 16/8/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBWinnerView : UIView

- (instancetype)initWithType:(YPBLuckyType)type;

@property (nonatomic) UIButton *repeatBtn;

@property (nonatomic) UIImageView * closeImgV;
@end
