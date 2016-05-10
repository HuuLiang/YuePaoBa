//
//  YPBPaymentInfo.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YPBPaymentStatus) {
    YPBPaymentStatusUnknown,
    YPBPaymentStatusPaying,
    YPBPaymentStatusNotProcessed,
    YPBPaymentStatusProcessed
};

typedef NS_ENUM(NSUInteger, YPBPayPointType) {
    YPBPayPointTypeUnknown = 9999,
    YPBPayPointTypeVIP = 1,
    YPBPayPointTypeGift = 2
};

typedef NS_ENUM(NSUInteger, YPBPaymentContentType) {
    YPBPaymentContentTypeUnknown = 0,
    YPBPaymentContentTypePhoto, //解锁图片付费
    YPBPaymentContentTypeVideo, //点击视频付费
    YPBPaymentContentTypeGift, //送礼物付费
    YPBPaymentContentTypeWeChatId, //获取微信号付费
    YPBPaymentContentTypeMessage, //聊天付费
    YPBPaymentContentTypeHomePageForMoreUsers, //首页加载更多用户付费
    YPBPaymentContentTypeGreetMore, //打更多招呼付费
    YPBPaymentContentTypeMineVIP, //我的页面 主动付费
    YPBPaymentContentTypeRenewVIP, //VIP续费
    YPBPaymnetContentTypeActivity //活动
};

@interface YPBPaymentInfo : NSObject

@property (nonatomic) NSString *paymentId;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSNumber *orderPrice;
@property (nonatomic) NSString *contentId;
@property (nonatomic) NSString *contentType;
@property (nonatomic) NSNumber *payPointType;
@property (nonatomic) NSNumber *monthsPaid; // VIP
@property (nonatomic) NSString *paymentTime;
@property (nonatomic) NSNumber *paymentType;
@property (nonatomic) NSNumber *paymentResult;
@property (nonatomic) NSNumber *paymentStatus;

+ (instancetype)paymentInfo;
+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment;
- (BOOL)isValid;
- (void)save;

@end
