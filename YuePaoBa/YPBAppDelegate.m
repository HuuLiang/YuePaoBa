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
#import "GeTuiSdk.h"

@interface YPBAppDelegate () <WXApiDelegate,UITabBarControllerDelegate,GeTuiSdkDelegate>
@property (nonatomic,retain) YPBWeChatPayQueryOrderRequest *wechatPayOrderQueryRequest;
@end

@implementation YPBAppDelegate
{
    UITabBarController * _tabBarController;
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
    YPBHomeViewController *homeVC = [[YPBHomeViewController alloc] initWithTitle:@"今日推荐"];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                       image:[UIImage imageNamed:@"tabbar_home_normal_icon"]
                                               selectedImage:[UIImage imageNamed:@"tabbar_home_selected_icon"]];

    YPBVIPCenterViewController *vipCenterVC = [[YPBVIPCenterViewController alloc] initWithTitle:@"视频认证"];
    UINavigationController *vipCenterNav = [[UINavigationController alloc] initWithRootViewController:vipCenterVC];
    vipCenterNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:vipCenterVC.title
                                                            image:[UIImage imageNamed:@"tabbar_video_normal_icon"]
                                                    selectedImage:[UIImage imageNamed:@"tabbar_video_selected_icon"]];
    
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
    
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    tabBarController.viewControllers = @[homeNav,vipCenterNav,contactNav,mineNav];
//    tabBarController.tabBar.tintColor = kThemeColor;
//    tabBarController.delegate = self;
//    return tabBarController;
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[homeNav,vipCenterNav,contactNav,mineNav];
    _tabBarController.tabBar.tintColor = kThemeColor;
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    DLog(@"--------launchOptions--------%@",launchOptions);
    application.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications]count] - 1;
    // 个推
    [GeTuiSdk startSdkWithAppId:YPB_GTAPPID appKey:YPB_GTAPPKEY appSecret:YPB_GTAPPSECRET delegate:self];
    [self registerNotification];
    [GeTuiSdk runBackgroundEnable:YES];
    [self receiveNotificationByLaunchingOptions:launchOptions];
    
    [[YPBErrorHandler sharedHandler] initialize];
    [self setupCommonStyles];
    [YPBStatistics start];
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
    DLog(@"---------views-------%ld",_tabBarController.viewControllers.count);
    UIViewController *viewcontroller3 = [_tabBarController.viewControllers objectAtIndex:2];
    UIViewController *viewcontroller4 = [_tabBarController.viewControllers objectAtIndex:3];
    NSInteger badge = [viewcontroller3.tabBarItem.badgeValue integerValue] + [viewcontroller4.tabBarItem.badgeValue integerValue];
    DLog(@"----------badge---------%ld",badge);
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    DLog(@"------------------ResignActive----------------");
    
    application.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications]count];
    DLog(@"------------------%ld",application.applicationIconBadgeNumber);
    
    [self setBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self checkPayment];
    DLog(@"=====BecomeActive=======");
    DLog(@"badgeNum %ld",[[[UIApplication sharedApplication]scheduledLocalNotifications]count]);
    application.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications]count];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
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
                    //[[YPBPaymentManager sharedManager] notifyPaymentResult:PAYRESULT_FAIL withPaymentInfo:paymentInfo];
                }
            }];
        } else {
//            paymentInfo.paymentResult = @(PAYRESULT_FAIL);
//            paymentInfo.paymentStatus = @(YPBPaymentStatusNotProcessed);
//            [paymentInfo save];
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

#pragma mark - 推送
// 注册APNS
- (void)registerNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

// 处理远程通知启动APP
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"APN%@,%@",[NSDate date],payloadMsg];
        NSLog(@"\n>>>[Launching RemoteNotification]:%@ %@", userInfo,record);
    }
}

/** 已登记用户通知 */
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GeTuiSdk registerDeviceToken:token];
    DLog(@"token---------------->%@",token);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [GeTuiSdk registerDeviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    DLog(@"----------------->点击通知进入");
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}


//此方法为sdk运行中的推送方法 可以从后台发送数据给客户端做逻辑判断  并不一定要展示 也可以收集用户运行数据等信息
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId {
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@" payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@",payloadId,taskId,aMsgId,payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
    
//    if (!offLine) {
        UILocalNotification *local = [[UILocalNotification alloc] init];
        local.fireDate = [[NSDate date] dateByAddingTimeInterval:0];
        local.timeZone = [NSTimeZone defaultTimeZone];
        local.alertBody = payloadMsg;
        local.soundName = UILocalNotificationDefaultSoundName;
        local.alertAction = NSLocalizedString(payloadMsg, nil);
        local.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications]count] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
//    }
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:tag], nil]
}

@end
