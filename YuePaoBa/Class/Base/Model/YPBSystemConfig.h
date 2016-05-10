//
//  YPBSystemConfig.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBAlipayConfig : NSObject
@property (nonatomic,retain) NSString *partner;
@property (nonatomic,retain) NSString *privateKey;
@property (nonatomic,retain) NSString *productInfo;
@property (nonatomic,retain) NSString *seller;
@property (nonatomic,retain) NSString *notifyUrl;

+ (instancetype)defaultConfig;

@end

@interface YPBWeChatPayConfig : NSObject
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

+ (instancetype)defaultConfig;
@end

@interface YPBSystemConfig : NSObject
@property (nonatomic) YPBAlipayConfig *alipayInfo;
@property (nonatomic) YPBWeChatPayConfig *weixinInfo;

@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSNumber *firstPayPages;
@property (nonatomic) NSString *vipPointInfo;
@property (nonatomic) NSString *ballPayWindowurl;
@property (nonatomic) NSString *payImgUrl;
@property (nonatomic) NSArray *userNames;

+ (instancetype)configFromPersistence;
+ (instancetype)sharedConfig;
- (void)persist;
- (NSDictionary *)vipPointDictionary;

@end
