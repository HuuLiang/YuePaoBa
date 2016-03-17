//
//  YPBUtil.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPaymentInfoKeyName;
@class YPBUser;
@class YPBPaymentInfo;

@interface YPBUtil : NSObject

+ (NSString *)activationId;
+ (void)setActivationId:(NSString *)activationId;

+ (void)notifyRegisterSuccessfully;
+ (NSString *)deviceRegisteredUserId;

+ (NSDate *)registerDate;
+ (NSUInteger)secondsSinceRegister;

+ (NSArray<YPBPaymentInfo *> *)allPaymentInfos;
+ (NSArray<YPBPaymentInfo *> *)payingPaymentInfos;
+ (NSArray<YPBPaymentInfo *> *)paidNotProcessedPaymentInfos;
+ (NSArray<YPBPaymentInfo *> *)allSuccessfulPaymentInfos;

+ (NSString *)vipExpireDate;
+ (void)setVIPExpireDate:(NSString *)dateString;
+ (NSString *)shortVIPExpireDate;
+ (NSString *)renewVIPByMonths:(NSUInteger)months;
+ (BOOL)isVIP;

+ (NSString *)deviceName;

+ (NSUInteger)loginFrequency;
+ (void)accumalateLoginFrequency;

+ (NSString *)currentDateString;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)priceStringWithValue:(NSUInteger)priceValue;

// For test only
+ (void)removeDeviceBinding;

@end
