//
//  YPBCommonDef.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef YPBCommonDef_h
#define YPBCommonDef_h

// DLog
#ifdef  DEBUG
#define DLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define DLog(...)
#endif

#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}

#define SafelyCallBlock(block) if (block) block();
#define SafelyCallBlock1(block, arg) if (block) block(arg);
#define SafelyCallBlock2(block, arg1, arg2) if (block) block(arg1, arg2);
#define SafelyCallBlock3(block, arg1, arg2, arg3) if (block) block(arg1, arg2, arg3);

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDefaultTextColor [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultBackgroundColor [UIColor colorWithWhite:0.97 alpha:1]
#define kDefaultCellHeight   (kScreenHeight * 0.08)
#define kDefaultDateFormat   @"yyyyMMddHHmmss"
#define kDefaultPhotoBlurRadius (5)
#define kThemeColor     [UIColor colorWithHexString:@"#ff6666"]

#define kUserInfoKeyName                @"yuepaoba_userinfo_keyname"
#define kUserIDKeyName                  @"yuepaoba_userid_keyname"
#define kUserGenderKeyName              @"yuepaoba_usergender_keyname"
#define kUserNicknameKeyName            @"yuepaoba_usernickname_keyname"
#define KUserPasswordKeyName            @"yuepaoba_userpassword_keyname"
#define kUserLogoKeyName                @"yuepaoba_userlogo_keyname"
#define kUserAgeKeyName                 @"yuepaoba_userage_keyname"
#define kUserHeightKeyName              @"yuepaoba_userheight_keyname"
#define kUserFigureKeyName              @"yuepaoba_userfigure_keyname"
#define kUserIncomeKeyName              @"yuepaoba_userincome_keyname"
#define kUserProvinceName               @"yuepaoba_userprovince_keyname"
#define kUserCityName                   @"yuepaoba_usercity_keyname"
#define kUserOpenidKeyName              @"yuepaoba_useropenid_keyname"
#define kUserUnionidKeyName             @"yuepaoba_userunionid_keyname"
#define kUserInterestKeyName            @"yuepaoba_userinterest_keyname"
#define kUserProfessionKeyName          @"yuepaoba_userprofession_keyname"
#define kUserWeChatKeyName              @"yuepaoba_userwechat_keyname"
#define kUserAssetsKeyName              @"yuepaoba_userassets_keyname"
#define kUserPurposeKeyName             @"yuepaoba_userpurpose_keyname"

#define kUserIsMemberKeyName            @"yuepaoba_userismember_keyname"
#define kUserIsVIPKeyName               @"yuepaoba_userisvip_keyname"

#define kUserMemberEndTimeKeyName       @"yuepaoba_usermemberendtime_keyname"
#define kUserVIPEndTimeKeyName          @"yuepaoba_uservipendtime_keyname"

#define kUserGreetCountKeyName          @"yuepaoba_usergreetcount_keyname"
#define kUserReceiveGreetCountKeyName   @"yuepaoba_userreceivegreetcount_keyname"
#define kUserAccessCountKeyName         @"yuepaoba_useraccesscount_keyname"

#define kUserReadGreetCountKeyName          @"yuepaoba_userreadgreetcount_keyname"
#define kUserReadReceiveGreetCountKeyName   @"yuepaoba_userreadreceivegreetcount_keyname"
#define kUserReadAccessCountKeyName         @"yuepaoba_userreadaccesscount_keyname"

#define kUserPhotosKeyName              @"yuepaoba_userphotos_keyname"
#define kUserGiftsKeyName               @"yuepaoba_usergifts_keyname"

#define kUserTargetHeightRangeKeyName   @"yuepaoba_usertargetheighrange_keyname"
#define kUserTargetAgeRangeKeyName      @"yuepaoba_usertargetagerange_keyname"
#define kUserTargetCupKeyName           @"yuepaoba_usertargetcup_keyname"

#define kUserContactPersistenceNamespace @"user_contact_persistence"
#define kUserMessagePersistenceNamespace @"user_message_persistence"
#define kAutoReplyMessagePersistentNamespace @"auto_reply_message_persistence"
#define kVIPUpgradePersistenceNamespace  @"vip_upgrade_persistence"
#define kUserLiveShowRoomPersistenceNamespace @"user_live_show_room_persistence"

#define kCurrentUserChangeNotification @"yuepaoba_current_user_change_notification"
//#define kUserContactNotification @"yuepaoba_user_contact_notification"
#define kMessagePushNotification            @"yuepaoba_message_push_notification"
#define kUserInRestoreNotification          @"yuepaoba_user_in_restore_notification"
#define kUserRestoreSuccessNotification     @"yuepaoba_user_restore_success_notification"
//#define kVIPUpgradingNotification           @"yuepaoba_vip_upgrading_notification"
#define kVIPUpgradeSuccessNotification      @"yuepaoba_vip_upgrade_success_notification"
#define kUnreadMessageChangeNotification    @"yuepaoba_unread_message_change_notification"

//个推信息
#define YPB_GTAPPID                   (@"A34dMAQ4BNA3MRLSR2m0n7")
#define YPB_GTAPPKEY                  (@"kFqXRs6ohv9lfGX1FE1tq2")
#define YPB_GTAPPSECRET               (@"s07xHhjpMd708Cc1bKzQl8")
#define YPB_GTMASTERSECRET            (@"iccRAoUFLAAxdQ0989mbS9")

#define SCREEN_WIDTH        [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen]bounds].size.height

typedef struct _YPBIntRange {
    NSInteger min;
    NSInteger max;
} YPBIntRange;

typedef struct _YPBFloatRange {
    CGFloat min;
    CGFloat max;
} YPBFloatRange;
 
#define SWAP(A,B) { typeof(A) temp = A; A = B; B = temp; }

typedef NSArray YPBPair;

typedef void (^YPBProgressHandler)(double progress);
typedef void (^YPBCompletionHandler)(BOOL success, id obj);
typedef void (^YPBAccountComplttionHandler)(BOOL success, id obj1 , id obj2);
typedef void (^YPBAction)(id obj);
typedef BOOL (^YPBStatusAction)(id obj);

typedef NS_ENUM(NSUInteger, YPBPaymentType) {
    YPBPaymentTypeNone,
    YPBPaymentTypeAlipay = 1001,
    YPBPaymentTypeWeChatPay = 1008,
    YPBPaymentTypeUPPay = 1009
};

typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
};
#endif /* YPBCommonDef_h */
