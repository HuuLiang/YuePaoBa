//
//  YPBVIPEntranceView.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBVIPEntranceView : UIView

@property (nonatomic,copy) YPBAction enterAction;

+ (instancetype)VIPEntranceInView:(UIView *)view;
+ (instancetype)showVIPEntranceInView:(UIView *)view canClose:(BOOL)canClose withEnterAction:(YPBAction)enterAction;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
