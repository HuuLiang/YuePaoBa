//
//  YPBActivityPayView.h
//  YuePaoBa
//
//  Created by Liang on 16/5/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closePayView)(void);

@interface YPBActivityPayView : UIView

@property (nonatomic) closePayView closeBlock;

@property (nonatomic) UIImage *img;

@property (nonatomic) BOOL closeBtnHidden;

@end
