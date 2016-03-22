//
//  YPBMessageCenter.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/15.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMessageCenter.h"
#import <TSMessage.h>

@implementation YPBMessageCenter

+ (instancetype)defaultCenter {
    static YPBMessageCenter *_defaultCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultCenter = [[self alloc] init];
    });
    return _defaultCenter;
}

+ (UIViewController *)currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController.presentedViewController) {
        return viewController.presentedViewController;
    } else {
        return viewController;
    }
}

//- (void)showMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
//    [TSMessage showNotificationInViewController:[self currentViewController] title:title subtitle:subtitle type:TSMessageNotificationTypeMessage];
//}
//
//- (void)showWarningWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
//    [TSMessage showNotificationInViewController:[self currentViewController] title:title subtitle:subtitle type:TSMessageNotificationTypeWarning];
//}
//
//- (void)showErrorWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
//    [TSMessage showNotificationInViewController:[self currentViewController] title:title subtitle:subtitle type:TSMessageNotificationTypeError];
//}
//
//- (void)showSuccessWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
//    [TSMessage showNotificationInViewController:[self currentViewController] title:title subtitle:subtitle type:TSMessageNotificationTypeSuccess];
//}

- (void)showMessageWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[YPBMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeMessage duration:2];
}

- (void)showWarningWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[YPBMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeWarning duration:2];
}

- (void)showErrorWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[YPBMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeError duration:2];
}

- (void)showSuccessWithTitle:(NSString *)title inViewController:(UIViewController *)viewController {
    [TSMessage showNotificationInViewController:[YPBMessageCenter currentViewController] title:title subtitle:nil type:TSMessageNotificationTypeSuccess duration:2];
}

- (void)dismissMessageWithCompletion:(void (^)(void))completion {
    [TSMessage dismissActiveNotificationWithCompletion:completion];
}

- (void)showProgressWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window beginProgressingWithTitle:title subtitle:subtitle];
}

- (void)proceedProgressWithPercent:(double)percent {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window progressWithPercent:percent];
}

- (void)hideProgress {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window endProgressing];
}
@end
