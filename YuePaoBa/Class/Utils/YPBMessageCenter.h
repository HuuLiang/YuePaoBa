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

- (void)showMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)showWarningWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)showErrorWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)showSuccessWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

- (void)dismissMessageWithCompletion:(void (^)(void))completion;

@end

#define YPBShowMessage(_title,_subtitle) [[YPBMessageCenter defaultCenter] showMessageWithTitle:_title subtitle:_subtitle]
#define YPBShowWarning(_title,_subtitle) [[YPBMessageCenter defaultCenter] showWarningWithTitle:_title subtitle:_subtitle]
#define YPBShowError(_title,_subtitle) [[YPBMessageCenter defaultCenter] showErrorWithTitle:_title subtitle:_subtitle]
#define YPBShowSuccess(_title,_subtitle) [[YPBMessageCenter defaultCenter] showSuccessWithTitle:_title subtitle:_subtitle]