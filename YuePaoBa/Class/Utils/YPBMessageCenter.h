//
//  YPBMessageCenter.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/15.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBMessageCenter : NSObject

+ (instancetype)defaultCenter;
- (instancetype)init __attribute__((unavailable("cannot use init for this class, use +(instancetype)defaultCenter instead")));

//- (void)showMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
//- (void)showWarningWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
//- (void)showErrorWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
//- (void)showSuccessWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

- (void)showMessageWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showWarningWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showErrorWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;
- (void)showSuccessWithTitle:(NSString *)title inViewController:(UIViewController *)viewController;

- (void)dismissMessageWithCompletion:(void (^)(void))completion;

- (void)showProgressWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)proceedProgressWithPercent:(double)percent;
- (void)hideProgress;

@end

#define YPBShowMessage(_title) [[YPBMessageCenter defaultCenter] showMessageWithTitle:_title inViewController:nil]
#define YPBShowWarning(_title) [[YPBMessageCenter defaultCenter] showWarningWithTitle:_title inViewController:nil]
#define YPBShowError(_title) [[YPBMessageCenter defaultCenter] showErrorWithTitle:_title inViewController:nil]
#define YPBShowSuccess(_title) [[YPBMessageCenter defaultCenter] showSuccessWithTitle:_title inViewController:nil]