//
//  AppDelegate.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBAppDelegate.h"
#import "YPBHomeViewController.h"
#import "YPBVIPCenterViewController.h"
#import "YPBContactViewController.h"
#import "YPBMineViewController.h"
#import "YPBSettingViewController.h"
#import "YPBLoginViewController.h"
#import "YPBActivateModel.h"
#import "YPBMessagePushModel.h"
#import "YPBAutoReplyMessagePool.h"

#import "WXApi.h"
#import "YPBPaymentInfo.h"
#import "YPBWeChatPayQueryOrderRequest.h"
#import "YPBPaymentModel.h"
#import "YPBUserVIPUpgradeModel.h"
#import "WeChatPayManager.h"
#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <KSCrash/KSCrashInstallationStandard.h>

#import "YPBSegmentViewController.h"

@interface YPBAppDelegate () <WXApiDelegate,UITabBarControllerDelegate>
@property (nonatomic,retain) YPBWeChatPayQueryOrderRequest *wechatPayOrderQueryRequest;
@end

@implementation YPBAppDelegate {
    UITabBarController *_tabBarController;
}

DefineLazyPropertyInitialization(YPBWeChatPayQueryOrderRequest, wechatPayOrderQueryRequest)

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    return _window;
}

- (UIViewController *)setupRootViewController {
    YPBSegmentViewController *homeVC = [[YPBSegmentViewController alloc] initWithTitle:@"今日推荐"];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                       image:[UIImage imageNamed:@"tabbar_home_normal_icon"]
                                               selectedImage:[UIImage imageNamed:@"tabbar_home_selected_icon"]];

    YPBVIPCenterViewController *vipCenterVC = [[YPBVIPCenterViewController alloc] initWithTitle:@"VIP服务区"];
    UINavigationController *vipCenterNav = [[UINavigationController alloc] initWithRootViewController:vipCenterVC];
    vipCenterNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:vipCenterVC.title
                                                            image:[UIImage imageNamed:@"tabbar_vip_normal_icon"]
                                                    selectedImage:[UIImage imageNamed:@"tabbar_vip_selected_icon"]];
    
    YPBContactViewController *contactVC = [[YPBContactViewController alloc] initWithTitle:@"消息"];
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactVC];
    contactNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:contactVC.title
                                                          image:[UIImage imageNamed:@"tabbar_message_normal_icon"]
                                                  selectedImage:[UIImage imageNamed:@"tabbar_message_selected_icon"]];
    
    YPBMineViewController *mineVC = [[YPBMineViewController alloc] initWithTitle:@"我"];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[UIImage imageNamed:@"tabbar_mine_normal_icon"]
                                               selectedImage:[UIImage imageNamed:@"tabbar_mine_selected_icon"]];
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[homeNav,vipCenterNav,contactNav,mineNav];
    _tabBarController.tabBar.tintColor = kThemeColor;
//    _tabBarController.tabBar.alpha = 0.5;
    _tabBarController.tabBar.translucent = NO;
    _tabBarController.delegate = self;
    return _tabBarController;
}

- (void)setupCommonStyles {
    [[UINavigationBar appearance] setBarTintColor:kThemeColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.],
                                                          NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
                                   
                               } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo)
    {
        UIViewController *thisVC = [aspectInfo instance];
        BOOL hidesBottomBar = NO;
        if (thisVC.navigationController.viewControllers.count > 1) {
            hidesBottomBar = YES;
        }
        [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
    } error:nil];
    
    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo){
                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                                     } error:nil];

    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                               } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                         withOptions:AspectPositionInstead
                          usingBlock:^(id<AspectInfo> aspectInfo)
    {
        BOOL bShow = NO;
        [[aspectInfo originalInvocation] setReturnValue:&bShow];
    } error:nil];
    
    
}

- (void)setupCrashReporter {
    KSCrashInstallationStandard* installation = [KSCrashInstallationStandard sharedInstance];
    installation.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://collector.bughd.com/kscrash?key=%@", YPB_KSCRASH_APP_ID]];
    [installation install];
    [installation sendAllReportsWithCompletion:nil];
}

//注册本地通知
- (void)registerUserNotifcation {
    if (NSClassFromString(@"UIUserNotificationSettings")) {
        UIUserNotificationType notiType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:notiType categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[YPBErrorHandler sharedHandler] initialize];
    [self setupCommonStyles];
    [YPBStatistics start];
//    [self registerUserNotifcation];
    [YPBUploadManager registerWithSecretKey:YPB_UPLOAD_SECRET_KEY accessKey:YPB_UPLOAD_ACCESS_KEY scope:YPB_UPLOAD_SCOPE];
    
    if ([YPBUtil deviceRegisteredUserId]) {
        [self notifyUserLogin];
    } else {
        YPBLoginViewController *loginVC = [[YPBLoginViewController alloc] init];
        self.window.rootViewController = loginVC;
        [self.window makeKeyAndVisible];
    }
    
    if (![YPBUtil activationId]) {
        [[YPBActivateModel sharedModel] requestActivationWithCompletionHandler:^(BOOL success, id obj) {
            if (success) {
                [YPBUtil setActivationId:obj];
            }
        }];
    }
    
    [[YPBSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success, id obj) {
        YPBSystemConfig *systemConfig = obj;
        [systemConfig persist];
        
        [WXApi registerApp:[YPBSystemConfig sharedConfig].weixinInfo.appId];
    }];
    
    [[YPBPaymentModel sharedModel] startRetryingToCommitUnprocessedOrders];
    [[YPBUserVIPUpgradeModel sharedModel] startRetryingToSynchronizeVIPInfos];
    [[YPBAutoReplyMessagePool sharedPool] startRollingMessagesToAutoReply];
    
    [self setupCrashReporter];
    return YES;
}

- (void)setBadge {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[_tabBarController.viewControllers objectAtIndex:2].tabBarItem.badgeValue integerValue] + [[_tabBarController.viewControllers objectAtIndex:3].tabBarItem.badgeValue integerValue];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self setBadge];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self checkPayment];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setBadge];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [[AlipayManager shareInstance] sendNotificationByResult:resultDic];
    }];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)checkPayment {
    NSArray<YPBPaymentInfo *> *payingPaymentInfos = [YPBUtil payingPaymentInfos];
    [payingPaymentInfos enumerateObjectsUsingBlock:^(YPBPaymentInfo * _Nonnull paymentInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        YPBPaymentType paymentType = paymentInfo.paymentType.unsignedIntegerValue;
        if (paymentType == YPBPaymentTypeWeChatPay) {
            [self.wechatPayOrderQueryRequest queryOrderWithNo:paymentInfo.orderId completionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
                if ([trade_state isEqualToString:@"SUCCESS"]) {
                    [[YPBPaymentManager sharedManager] notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:paymentInfo];
                } else {
                    [[YPBPaymentManager sharedManager] notifyPaymentResult:PAYRESULT_FAIL withPaymentInfo:paymentInfo];
                }
            }];
        } else {
            paymentInfo.paymentResult = @(PAYRESULT_FAIL);
            paymentInfo.paymentStatus = @(YPBPaymentStatusNotProcessed);
            [paymentInfo save];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kVIPUpgradingNotification object:paymentInfo];
        }
    }];
}

- (void)notifyUserLogin {
    self.window.rootViewController = [self setupRootViewController];
    [self.window makeKeyAndVisible];
    
    [[YPBMessagePushModel sharedModel] notifyLoginPush];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInRestoreNotification object:nil];
}

#pragma mark - WeChat delegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        PAYRESULT payResult;
        if (resp.errCode == WXErrCodeUserCancel) {
            payResult = PAYRESULT_ABANDON;
        } else if (resp.errCode == WXSuccess) {
            payResult = PAYRESULT_SUCCESS;
        } else {
            payResult = PAYRESULT_FAIL;
        }
        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
    }
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (![YPBUser currentUser].isRegistered) {
        return ;
    }
    
    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    if (index != NSNotFound) {
        [YPBStatistics logEvent:kLogUserTabClickEvent withUser:[YPBUser currentUser].userId attributeKey:@"序号" attributeValue:@(index).stringValue];
    }
}


@end
