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

static NSString *const kRegisterDateKeyChainServiceName = @"YPB_REGISTERDATE_KEYCHAIN_SERVICENAME";
static NSString *const kRegisterDateKeyChainUserName = @"YPB_REGISTERDATE_KEYCHAIN_USERNAME";

static NSString *const kRegisterUserIdKeyChainServiceName = @"YPB_REGISTERUSERID_KEYCHAIN_SERVICENAME";
static NSString *const kRegisterUserIdKeyChainUserName = @"YPB_REGISTERUSERID_KEYCHAIN_USERNAME";

static NSString *const kLoginFrequencyKeyName = @"YPB_LOGINFREQUENCY_KEYNAME";

@implementation YPBUtil

+ (RESideMenu *)sideMenuViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow.rootViewController isKindOfClass:[RESideMenu class]]) {
        return (RESideMenu *)keyWindow.rootViewController;
    }
    return nil;
}

+ (void)notifyRegisterSuccessfully {
    [SFHFKeychainUtils storeUsername:kRegisterUserIdKeyChainUserName
                         andPassword:[YPBUser currentUser].userId
                      forServiceName:kRegisterUserIdKeyChainServiceName
                      updateExisting:NO error:nil];
    
    [SFHFKeychainUtils storeUsername:kRegisterDateKeyChainUserName
                         andPassword:[self currentDateString]
                      forServiceName:kRegisterDateKeyChainServiceName
                      updateExisting:NO
                               error:nil];
    
    YPBAppDelegate *delegate = (YPBAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate notifyLoginSuccessfully];
}

+ (NSString *)deviceRegisteredUserId {
    return [SFHFKeychainUtils getPasswordForUsername:kRegisterUserIdKeyChainUserName
                                      andServiceName:kRegisterUserIdKeyChainServiceName
                                               error:nil];
}

+ (NSDate *)registerDate {
    NSString *dateString = [SFHFKeychainUtils getPasswordForUsername:kRegisterDateKeyChainUserName
                                                      andServiceName:kRegisterDateKeyChainServiceName
                                                               error:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormat];
    return [dateFormatter dateFromString:dateString];
}

+ (NSUInteger)secondsSinceRegister {
    NSDate *registerDate = [self registerDate];
    NSDateComponents *dateComps = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:registerDate toDate:[NSDate date] options:0];
    return dateComps.second;
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

+ (NSUInteger)loginFrequency {
    NSNumber *times = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginFrequencyKeyName];;
    return times.unsignedIntegerValue;
}

+ (void)accumalateLoginFrequency {
    NSUInteger loginFreq = [self loginFrequency];
    [[NSUserDefaults standardUserDefaults] setObject:@(loginFreq+1) forKey:kLoginFrequencyKeyName];
}

+ (NSString *)currentDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormat];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormat];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDefaultDateFormat];
    return [dateFormatter stringFromDate:date];
}
@end
