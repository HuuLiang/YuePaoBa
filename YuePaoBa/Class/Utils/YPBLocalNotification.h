//
//  YPBLocalNotification.h
//  YuePaoBa
//
//  Created by Liang on 16/3/30.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBLocalNotification : NSObject

+ (instancetype)sharedInstance;

- (void)createLocalNotificationWithMessage:(NSString *)message Date:(NSDate *)date;

- (void)createLocalNotificationWithMessage:(NSString *)message Date:(NSDate *)date BlacklistUesrId:(NSString *)userId;

- (void)checkLocalNotificationWithUserId:(NSString *)userId;

@end
