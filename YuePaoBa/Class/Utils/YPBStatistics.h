//
//  YPBStatistics.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBStatistics : NSObject

+ (void)start;

+ (void)logEvent:(NSString *)eventId fromUser:(NSString *)fromUserId toUser:(NSString *)toUserId;
+ (void)logEvent:(NSString *)eventId withUser:(NSString *)userId attributeKey:(NSString *)key attributeValue:(NSString *)value;
+ (void)logEvent:(NSString *)eventId fromUser:(NSString *)fromUserId toUser:(NSString *)toUserId withAttributes:(NSDictionary *)attrs;

@end

extern NSString *const kLogUserDetailViewedEvent;
extern NSString *const kLogUserVideoViewedEvent;
extern NSString *const kLogUserPhotoViewedEvent;
extern NSString *const kLogUserWeChatViewedForPaymentEvent;
extern NSString *const kLogUserGiftPageViewedEvent;
extern NSString *const kLogUserDateEvent;
extern NSString *const kLogUserChatEvent;

extern NSString *const kLogUserTabClickEvent;
extern NSString *const kLogUserHomeClickEvent;
extern NSString *const kLogUserGiftButtonClickEvent;

extern NSString *const kLogUserTabActivityButtomEvent;
extern NSString *const kLogUserTabActivityBannerEvent;
extern NSString *const kLogUserTAbActivityChargesEvent;