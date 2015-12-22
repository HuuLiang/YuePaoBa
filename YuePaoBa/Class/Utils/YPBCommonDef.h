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

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define CONTENT_VIEW_OFFSET_CENTERX (kScreenWidth/4)

#define kUserInfoKeyName     @"yuepaoba_userinfo_keyname"
#define kUserIDKeyName       @"yuepaoba_userid_keyname"
#define kUserGenderKeyName   @"yuepaoba_usergender_keyname"
#define kUserNicknameKeyName @"yuepaoba_usernickname_keyname"
#define kUserTargetHeightRangeKeyName @"yuepaoba_usertargetheighrange_keyname"
#define kUserTargetAgeRangeKeyName    @"yuepaoba_usertargetagerange_keyname"
#define kUserTargetCupKeyName         @"yuepaoba_usertargetcup_keyname"

#define kCurrentUserChangeNotification @"yuepaoba_current_user_change_notification"

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

typedef void (^YPBCompletionHandler)(BOOL success, id obj);

#endif /* YPBCommonDef_h */
