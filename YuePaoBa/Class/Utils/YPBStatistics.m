//
//  YPBStatistics.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBStatistics.h"
#import "MobClick.h"

NSString *const kLogUserDetailViewedEvent           = @"YPB_USER_DETAIL_VIEWED";
NSString *const kLogUserVideoViewedEvent            = @"YPB_USER_VIDEO_VIEWED";
NSString *const kLogUserPhotoViewedEvent            = @"YPB_USER_PHOTO_VIEWED";
NSString *const kLogUserWeChatViewedForPaymentEvent = @"YPB_USER_WECHAT_VIEWED_FOR_PAYMENT";
NSString *const kLogUserGiftPageViewedEvent         = @"YPB_USER_GIFT_PAGE_VIEWED";
NSString *const kLogUserDateEvent                   = @"YPB_USER_DATE";
NSString *const kLogUserChatEvent                   = @"YPB_USER_CHAT";

NSString *const kLogUserTabClickEvent               = @"YPB_USER_TAB_CLICK";
NSString *const kLogUserHomeClickEvent              = @"YPB_USER_HOME_CLICK";
NSString *const kLogUserGiftButtonClickEvent        = @"YPB_USER_GIFT_BUTTON_CLICK";

@implementation YPBStatistics

+ (void)start {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
    NSLog(@"%@",[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@".umeng"]);
#endif
    [MobClick setCrashReportEnabled:NO];
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:YPB_UMENG_APP_ID reportPolicy:BATCH channelId:YPB_CHANNEL_NO];
}

+ (void)logEvent:(NSString *)eventId
        fromUser:(NSString *)fromUserId
          toUser:(NSString *)toUserId
{
    [self logEvent:eventId fromUser:fromUserId toUser:toUserId withAttributes:nil];
}

+ (void)logEvent:(NSString *)eventId
        withUser:(NSString *)userId
    attributeKey:(NSString *)key
  attributeValue:(NSString *)value
{
    if (userId == nil) {
        return ;
    }
    
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] initWithDictionary:@{@"用户ID":userId}];
    [attrs safely_setObject:value forKey:key];
    
    [MobClick event:eventId attributes:attrs];
}

+ (void)logEvent:(NSString *)eventId
        fromUser:(NSString *)fromUserId
          toUser:(NSString *)toUserId
  withAttributes:(NSDictionary *)attrs
{
    if (fromUserId == nil || toUserId == nil) {
        return ;
    }
    
    NSMutableDictionary *logAttrs = [[NSMutableDictionary alloc] initWithDictionary:@{@"主动用户ID":fromUserId, @"被动用户ID":toUserId}];
    if (attrs.count > 0) {
        [logAttrs addEntriesFromDictionary:attrs];
    }
    
    [MobClick event:eventId attributes:attrs];
}
@end
