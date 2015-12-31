//
//  AppDelegate.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBAppDelegate.h"
#import "YPBSideMenuViewController.h"
#import "YPBHomeViewController.h"
#import "YPBVIPCenterViewController.h"
#import "YPBMessageViewController.h"
#import "YPBMineViewController.h"
#import "YPBSettingViewController.h"
#import "YPBLoginViewController.h"
#import "YPBActivateModel.h"

@interface YPBAppDelegate ()

@end

@implementation YPBAppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
//    _window.rootViewController           = [self setupRootViewController];
    return _window;
}

- (UIViewController *)setupRootViewController {
    YPBMineViewController *mineVC = [[YPBMineViewController alloc] initWithTitle:@"个人资料"];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.sideMenuItem = [YPBSideMenuItem itemWithTitle:nil image:nil delegate:mineVC];
    
    YPBHomeViewController *homeVC = [[YPBHomeViewController alloc] initWithTitle:@"今日推荐"];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.sideMenuItem = [YPBSideMenuItem itemWithTitle:homeVC.title image:[UIImage imageNamed:@"side_menu_hot_icon"]];
    
    YPBVIPCenterViewController *vipCenterVC = [[YPBVIPCenterViewController alloc] initWithTitle:@"VIP服务区"];
    UINavigationController *vipCenterNav = [[UINavigationController alloc] initWithRootViewController:vipCenterVC];
    vipCenterNav.sideMenuItem = [YPBSideMenuItem itemWithTitle:vipCenterVC.title image:[UIImage imageNamed:@"side_menu_vip_icon"]];
    
    YPBMessageViewController *messageVC = [[YPBMessageViewController alloc] initWithTitle:@"私密聊"];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    messageNav.sideMenuItem = [YPBSideMenuItem itemWithTitle:messageVC.title image:[UIImage imageNamed:@"side_menu_message_icon"]];
    
    YPBSettingViewController *settingVC = [[YPBSettingViewController alloc] initWithTitle:@"设置"];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
    settingNav.sideMenuItem = [YPBSideMenuItem itemWithTitle:settingVC.title image:[UIImage imageNamed:@"side_menu_setting_icon"]];
    
    
    YPBSideMenuViewController *sideMenuVC = [[YPBSideMenuViewController alloc] initWithViewControllers:@[mineNav,homeNav,vipCenterNav,messageNav,settingNav]];
    
    RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:homeNav
                                                      leftMenuViewController:sideMenuVC
                                                     rightMenuViewController:nil];
    sideMenu.delegate = sideMenuVC;
    sideMenu.scaleContentView = NO;
    sideMenu.scaleBackgroundImageView = NO;
    sideMenu.scaleMenuView = NO;
    sideMenu.fadeMenuView = NO;
    sideMenu.parallaxEnabled = NO;
    sideMenu.bouncesHorizontally = NO;
    sideMenu.contentViewShadowEnabled = YES;
    sideMenu.contentViewShadowOffset = CGSizeMake(2.0, 0.0f);
    sideMenu.contentViewShadowOpacity = 0.8;
    sideMenu.contentViewShadowColor = [UIColor whiteColor];
    sideMenu.contentViewInPortraitOffsetCenterX = CONTENT_VIEW_OFFSET_CENTERX;
    return sideMenu;
}

- (void)setupCommonStyles {
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationController.navigationBar.translucent = NO;
                                   thisVC.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff6666"];
                                   thisVC.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.],
                                                                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
                                   thisVC.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
                                   
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
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[YPBErrorHandler sharedHandler] initialize];
    [self setupCommonStyles];
    [YPBUploadManager registerWithSecretKey:YPB_UPLOAD_SECRET_KEY accessKey:YPB_UPLOAD_ACCESS_KEY scope:YPB_UPLOAD_SCOPE];
    
    if ([[YPBUser currentUser] isRegistered]) {
        self.window.rootViewController = [self setupRootViewController];
    } else {
        YPBLoginViewController *loginVC = [[YPBLoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }
    [self.window makeKeyAndVisible];
    
    if (![YPBUtil activationId]) {
        [[YPBActivateModel sharedModel] requestActivationWithCompletionHandler:^(BOOL success, id obj) {
            if (success) {
                [YPBUtil setActivationId:obj];
            }
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)notifyRegisterSuccessfully {
    self.window.rootViewController = [self setupRootViewController];
}
@end
