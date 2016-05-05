//
//  YPBConfig.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/19.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef YPBConfig_h
#define YPBConfig_h

#define YPB_CHANNEL_NO       @"QB_MFW_IOS_STORE_TUIGUANG"//@"QB_MFW_IOS_F_00000001"//@"QB_MFW_IOS_TEST_0000001" //

#define YPB_REST_APPID       @"QUBA_2003"
#define YPB_REST_PV          @"100"
#define YPB_REST_APP_VERSION     ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define YPB_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", YPB_REST_APPID, YPB_CHANNEL_NO]

#define YPB_BASE_URL                    @"http://mfw.ihuiyx.com"//@"http://120.24.252.114:8094"//@"http://192.168.1.123:8094/"
#define YPB_USER_ACTIVATION_URL         @"/mfwcenter/jihuo.json"
#define YPB_USER_REGISTER_URL           @"/mfwcenter/userCreate.json"
#define YPB_USER_LIST_URL               @"/mfwcenter/userQuery.json"
#define YPB_USER_DETAIL_URL             @"/mfwcenter/userCenter.json"
#define YPB_USER_GREET_OR_VIEW_URL      @"/mfwcenter/userGreet.json"
#define YPB_USER_DETAIL_UPDATE_URL      @"/mfwcenter/updateUser.json"
#define YPB_USER_ACCESS_QUERY_URL       @"/mfwcenter/queryAccess.json"
#define YPB_USER_AVATAR_UPDATE_URL      @"/mfwcenter/updateUserlogo.json"
#define YPB_USER_PHOTO_ADD_URL          @"/mfwcenter/photoCreate.json"
#define YPB_USER_VIP_UPGRADE_URL        @"/mfwcenter/updateUserVip.json"
#define YPB_USER_PHOTO_DELETE_URL       @"/mfwcenter/updatePhotoStatus.json"
#define YPB_SEND_BARRAGE_URL            @"/mfwcenter/createBarrage.json"
#define YPB_GIFT_LIST_URL               @"/mfwcenter/queryGifts.json"
#define YPB_USER_RECEIVED_GIFTS_URL     @"/mfwcenter/userReceiveGifts.json"
#define YPB_USER_SENT_GIFTS_URL         @"/mfwcenter/userSendGifts.json"
#define YPB_FETCH_BARRAGES_URL          @"/mfwcenter/barrages.json"
#define YPB_SEND_GIFT_URL               @"/mfwcenter/giveGift.json"
#define YPB_UPDATE_CID_URL              @"/mfwcenter/updateCId.json"
#define YPB_SEND_MSG_URL                @"/mfwcenter/smsg.json"
#define YPB_REPORT_URL                  @"/mfwcenter/report.json"

#define YPB_PAYMENT_COMMIT_URL          @"http://pay.iqu8.net/paycenter/qubaPr.json" //@"http://120.24.252.114:8084/paycenter/qubaPr.json" //
#define YPB_ALIPAY_SCHEME               @"comyuepaobaappalipayschemeurl"

#define YPB_USER_MESSAGE_PUSH_URL       @"/mfwcenter/loginPush.json"
#define YPB_SYSTEM_CONFIG_URL           @"/mfwcenter/systemConfig.json"
#define YPB_FEEDBACK_URL                @"/mfwcenter/feedback.json"

#define YPB_AGREEMENT_URL               @"http://7xomw1.com2.z0.glb.qiniucdn.com/mfw/mfwuseragree.html"
#define YPB_QANDA_URL                   @"http://7xomw1.com2.z0.glb.qiniucdn.com/mfw/mfwuserquestions.html"

#define YPB_UPLOAD_SCOPE                @"mfw-photo"
#define YPB_UPLOAD_SECRET_KEY           @"K9cjaa7iip6LxVT9zo45p7DiVxEIo158NTUfJ7dq"
#define YPB_UPLOAD_ACCESS_KEY           @"02q5Mhx6Tfb525_sdU_VJV6po2MhZHwdgyNthI-U"

#define YPB_DEFAULT_PHOTOSERVER_URL     @"http://7xpobi.com2.z0.glb.qiniucdn.com"

#define YPB_UMENG_APP_ID                @"569f30e6e0f55a0373002331"
#define YPB_KSCRASH_APP_ID              @"6f10027627cbed6fd17c676e88c4989b" 

#define YPB_DB_VERSION                  (1)
#endif /* YPBConfig_h */
