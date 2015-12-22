//
//  YPBUtil.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUtil.h"
#import "YPBAppDelegate.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>

// Activation
static NSString *const kActivationKeyChainServiceName = @"YPB_ACTIVATION_KEYCHAIN_SERVICENAME";
static NSString *const kActivationKeyChainUserName = @"YPB_ACTIVATION_KEYCHAIN_USERNAME";

@implementation YPBUtil

+ (RESideMenu *)sideMenuViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow.rootViewController isKindOfClass:[RESideMenu class]]) {
        return (RESideMenu *)keyWindow.rootViewController;
    }
    return nil;
}

+ (void)notifyRegisterSuccessfully {
    YPBAppDelegate *delegate = (YPBAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate notifyRegisterSuccessfully];
}

+ (NSString *)activationId {
    return [SFHFKeychainUtils getPasswordForUsername:kActivationKeyChainUserName andServiceName:kActivationKeyChainServiceName error:nil];
}

+ (void)setActivationId:(NSString *)activationId {
    [SFHFKeychainUtils storeUsername:kActivationKeyChainUserName andPassword:activationId forServiceName:kActivationKeyChainServiceName updateExisting:NO error:nil];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)appId {
    return @"QUBA_2001";
}

+ (NSNumber *)pV {
    return @200;
}
@end
