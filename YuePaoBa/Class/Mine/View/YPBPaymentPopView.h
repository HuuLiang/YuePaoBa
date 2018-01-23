//
//  YPBPaymentPopView.h
//  YPBuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBPaymentPopView : UITableView

//@property (nonatomic,copy) YPBAction closeAction;
//@property (nonatomic) NSNumber *showPrice;

+ (instancetype)popPaymentInView:(UIView *)superview;

- (void)addPaymentWithImage:(UIImage *)image title:(NSString *)title available:(BOOL)available action:(YPBAction)action;
- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width;
- (void)showInView:(UIView *)superview;
- (void)hide;

@end
