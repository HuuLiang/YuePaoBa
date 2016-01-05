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

#define CONTENT_VIEW_OFFSET_CENTERX (kScreenWidth/4)

#define kUserInfoKeyName                @"yuepaoba_userinfo_keyname"
#define kUserIDKeyName                  @"yuepaoba_userid_keyname"
#define kUserGenderKeyName              @"yuepaoba_usergender_keyname"
#define kUserNicknameKeyName            @"yuepaoba_usernickname_keyname"
#define kUserLogoKeyName                @"yuepaoba_userlogo_keyname"
#define kUserAgeKeyName                 @"yuepaoba_userage_keyname"
#define kUserHeightKeyName              @"yuepaoba_userheight_keyname"
#define kUserFigureKeyName              @"yuepaoba_userfigure_keyname"
#define kUserIncomeKeyName              @"yuepaoba_userincome_keyname"
#define kUserInterestKeyName            @"yuepaoba_userinterest_keyname"
#define kUserProfessionKeyName          @"yuepaoba_userprofession_keyname"
#define kUserWeChatKeyName              @"yuepaoba_userwechat_keyname"
#define kUserAssetsKeyName              @"yuepaoba_userassets_keyname"

#define kUserIsMemberKeyName            @"yuepaoba_userismember_keyname"
#define kUserIsVIPKeyName               @"yuepaoba_userisvip_keyname"

#define kUserMemberEndTimeKeyName       @"yuepaoba_usermemberendtime_keyname"
#define kUserVIPEndTimeKeyName          @"yuepaoba_uservipendtime_keyname"

#define kUserGreetCountKeyName          @"yuepaoba_usergreetcount_keyname"
#define kUserReceiveGreetCountKeyName   @"yuepaoba_userreceivegreetcount_keyname"
#define kUserAccessCountKeyName         @"yuepaoba_useraccesscount_keyname"

#define kUserTargetHeightRangeKeyName   @"yuepaoba_usertargetheighrange_keyname"
#define kUserTargetAgeRangeKeyName      @"yuepaoba_usertargetagerange_keyname"
#define kUserTargetCupKeyName           @"yuepaoba_usertargetcup_keyname"

//#define kCurrentUserChangeNotification @"yuepaoba_current_user_change_notification"

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
typedef void (^YPBAction)(id obj);
typedef BOOL (^YPBStatusAction)(id obj);
#endif /* YPBCommonDef_h */
