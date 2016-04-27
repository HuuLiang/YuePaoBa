//
//  YPBLocalNotification.m
//  YuePaoBa
//
//  Created by Liang on 16/3/30.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLocalNotification.h"

@implementation YPBLocalNotification

+ (instancetype)sharedInstance {
    static YPBLocalNotification *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YPBLocalNotification alloc] init];
    });
    return _sharedInstance;
}

//将机器人的回复写入本地通知发送给用户
- (void)createLocalNotificationWithMessage:(NSString *)message Date:(NSDate *)date {
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.fireDate = date;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.alertBody = message;
    noti.soundName = UILocalNotificationDefaultSoundName;
    noti.alertAction = @"";
    NSDictionary * dic = @{@"userId":@"YPBPusnSystemInfo"};
    [noti setUserInfo:dic];
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];

}

- (void)createLocalNotificationWithMessage:(NSString *)message Date:(NSDate *)date BlacklistUesrId:(NSString *)userId {
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    noti.fireDate = date;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.alertBody = message;
    noti.soundName = UILocalNotificationDefaultSoundName;
    noti.alertAction = @"";
    NSDictionary * dic = @{@"userId":userId};
    [noti setUserInfo:dic];
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)checkLocalNotificationWithUserId:(NSString *)userId {
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
       for (UILocalNotification *noti in narry) {
        NSDictionary *userInfo = noti.userInfo;
        if ([userInfo[@"userId"] isEqualToString:userId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
        }
    }
}


@end
