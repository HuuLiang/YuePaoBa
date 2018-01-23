//
//  YPBAppDelegate.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@protocol checkRegisterWeChatDelegate <NSObject>

- (void)checkRegisterWeChat;

- (void)sendAuthRespCode:(BaseResp *)resp;

@end

@interface YPBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,weak) id<checkRegisterWeChatDelegate>delegate;

@property (strong, nonatomic) UIWindow *window;

- (void)notifyUserLogin;

- (void)loginAccount;

@end

