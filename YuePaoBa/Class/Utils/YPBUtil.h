//
//  YPBUtil.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPBUser;

@interface YPBUtil : NSObject

+ (RESideMenu *)sideMenuViewController;

+ (NSString *)activationId;
+ (void)setActivationId:(NSString *)activationId;

+ (void)notifyRegisterSuccessfully;
+ (NSString *)deviceRegisteredUserId;

+ (NSDate *)registerDate;
+ (NSUInteger)secondsSinceRegister;

+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (NSString *)appId;
+ (NSNumber *)pV;

+ (NSUInteger)loginFrequency;
+ (void)accumalateLoginFrequency;

+ (NSString *)currentDateString;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
