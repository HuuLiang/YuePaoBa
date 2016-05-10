//
//  YPBSystemConfig.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSystemConfig.h"
#import "NSMutableDictionary+Safety.h"

static NSString *const kSystemConfigKeyName = @"yuepaoba_systemconfig_keyname";

@implementation YPBAlipayConfig

+ (instancetype)defaultConfig {
    YPBAlipayConfig *defaultConfig = [[self alloc] init];
    defaultConfig.partner = @"2088121511256613";
    defaultConfig.seller = @"wuyp@iqu8.cn";
    defaultConfig.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyByAlipay.json";
    defaultConfig.productInfo = @"相约交友";
    defaultConfig.privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMXv/hpnzbA3rO/P5KJKatb3NugTw965VYzcdEFyv38iIpMA3io7/kEcuMRGMDQ0VQJgNaF8/sHDu/j/+NPSDBzeOKtsqVsZoY5jKK1K43LujAYz2v8lvNLkFcaFoUhfMXHhxNnoHNtGXIadhHFK+v2a1l3YCZiP5XJ3rQo1FbrBAgMBAAECgYA4XFbJZAdQhvnqKxMaFwCHB0uOF5qtP66Zdmhv/mGCrNCVdSjNc9m45pnB4Y52PvR5wbVjrzjHKZnLk+9hOS0TRkbOmiuCfxB2doB3YMeGlgo+rPSUL0Ey5WKF8+IJvImQfgf8kgJlU/7RPeAtfY+pmxY9PvbULHKGS5q8KHXLFQJBAPtJ0S1idGtnRXX8f2+I7aqmxnH3QwVtU2DhN++l6n+XIEWmNgvVJoLY/bdtK84lKZl9nJw3hSVZ6C6qN1F7up8CQQDJphduiRVezGSR0ofcOBwT/jTxynovFH4zhdWLu/4f3p9fHvKFqYqdgv8Z5lUr4W6Bga+k0hLuqGvJjXAyI+6fAkAvHqNjsD+GWEIVIri+sF1oj4dMnYHqxZpJ41F61ZDIRg1eIhGmXFyxUoEY4RbCvAM17fDs9hg4bch036Qp2lqfAkBj9VByO8P7LSjBXHJ6iNnqUz4dibhNtEPm+HXmAbe0RqAMAARKm8OZ1wDr7tDTorkru4S9GGHIKnbb/5/ZSxSTAkB+cIT779yzXIVZYNj8Q2C+FMiHdUrw9OVikW6nKRcIlJJMBQfPzvjfR5ux0NVi1CM76hl5C4f4GSKFgM7AYXwX";
    return defaultConfig;
}

- (BOOL)isValid {
    return self.partner.length > 0 && self.privateKey.length > 0 && self.seller.length > 0 && self.notifyUrl.length > 0;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (dic.count == 0) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        self.partner = dic[@"partner"];
        self.privateKey = dic[@"privateKey"];
        self.productInfo = dic[@"productInfo"];
        self.seller = dic[@"seller"];
        self.notifyUrl = dic[@"notifyUrl"];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safely_setObject:self.partner forKey:@"partner"];
    [dic safely_setObject:self.privateKey forKey:@"privateKey"];
    [dic safely_setObject:self.productInfo forKey:@"productInfo"];
    [dic safely_setObject:self.seller forKey:@"seller"];
    [dic safely_setObject:self.notifyUrl forKey:@"notifyUrl"];
    return dic.count > 0 ? dic : nil;
}

@end

@implementation YPBWeChatPayConfig

+ (instancetype)defaultConfig {
    YPBWeChatPayConfig *defaultConfig = [[self alloc] init];
    defaultConfig.appId = @"wx2b2846687e296e95";
    defaultConfig.mchId = @"1297978401";
    defaultConfig.signKey = @"hangzhouQUYA20160112tcjiaoYOUpay";
    defaultConfig.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWx.json";
    return defaultConfig;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (dic.count == 0) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        self.appId = dic[@"appId"];
        self.mchId = dic[@"mchId"];
        self.signKey = dic[@"signKey"];
        self.notifyUrl = dic[@"notifyUrl"];
    }
    return self;
}
- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safely_setObject:self.appId forKey:@"appId"];
    [dic safely_setObject:self.mchId forKey:@"mchId"];
    [dic safely_setObject:self.signKey forKey:@"signKey"];
    [dic safely_setObject:self.notifyUrl forKey:@"notifyUrl"];
    return dic.count > 0 ? dic : nil;
}

- (BOOL)isValid {
    return self.appId.length > 0 && self.mchId.length > 0 && self.signKey.length > 0 && self.notifyUrl.length > 0;
}
@end

static YPBSystemConfig *_sharedConfig;

@implementation YPBSystemConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [self configFromPersistence];
    });
    
    if (!_sharedConfig.alipayInfo.isValid) {
        _sharedConfig.alipayInfo = [[self defaultConfig] alipayInfo];
    }
    
    if (!_sharedConfig.weixinInfo.isValid) {
        _sharedConfig.weixinInfo = [[self defaultConfig] weixinInfo];
    }
    
    if (_sharedConfig.imgUrl.length == 0) {
        _sharedConfig.imgUrl = [[self defaultConfig] imgUrl];
    }
    
    if (_sharedConfig.firstPayPages == nil) {
        _sharedConfig.firstPayPages = [[self defaultConfig] firstPayPages];
    }
    
    if (_sharedConfig.vipPointInfo.length == 0) {
        _sharedConfig.vipPointInfo = [[self defaultConfig] vipPointInfo];
    }
    return _sharedConfig;
}

+ (instancetype)defaultConfig {
    static YPBSystemConfig *_defaultConfig;
    static dispatch_once_t defaultToken;
    dispatch_once(&defaultToken, ^{
        _defaultConfig = [[self alloc] init];
        _defaultConfig.alipayInfo = [YPBAlipayConfig defaultConfig];
        _defaultConfig.weixinInfo = [YPBWeChatPayConfig defaultConfig];
        _defaultConfig.imgUrl = YPB_DEFAULT_PHOTOSERVER_URL;
        _defaultConfig.firstPayPages = @2;
        _defaultConfig.vipPointInfo = @"4800:1|9800:3";
    });
    return _defaultConfig;
}
- (Class)alipayInfoClass {
    return [YPBAlipayConfig class];
}

- (Class)weixinInfoClass {
    return [YPBWeChatPayConfig class];
}

+ (instancetype)configFromPersistence {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigKeyName];
    return [[self alloc] initFromDictionary:dic];
}

- (instancetype)initFromDictionary:(NSDictionary *)dic {
    self = [self init];
    if (self) {
        self.imgUrl = dic[@"imgUrl"];
        self.firstPayPages = dic[@"firstPayPages"];
        self.vipPointInfo = dic[@"vipPointInfo"];
        self.ballPayWindowurl = dic[@"ballPayWindowurl"];
        self.payImgUrl = dic[@"payImgUrl"];
        self.userNames = dic[@"userNames"];
        
        self.alipayInfo = [[YPBAlipayConfig alloc] initWithDictionary:dic[@"alipayInfo"]];
        self.weixinInfo = [[YPBWeChatPayConfig alloc] initWithDictionary:dic[@"weixinInfo"]];
    }
    return self;
}

- (void)persist {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigKeyName];
    NSMutableDictionary *persistDic = [dic mutableCopy];
    if (!persistDic) {
        persistDic = [NSMutableDictionary dictionary];
    }

    [persistDic safely_setObject:self.imgUrl forKey:@"imgUrl"];
    [persistDic safely_setObject:self.firstPayPages forKey:@"firstPayPages"];
    [persistDic safely_setObject:self.vipPointInfo forKey:@"vipPointInfo"];
    [persistDic safely_setObject:self.ballPayWindowurl forKey:@"ballPayWindowurl"];
    [persistDic safely_setObject:self.payImgUrl forKey:@"payImgUrl"];
    [persistDic safely_setObject:self.userNames forKey:@"userNames"];
    [persistDic safely_setObject:self.alipayInfo.dictionaryRepresentation forKey:@"alipayInfo"];
    [persistDic safely_setObject:self.weixinInfo.dictionaryRepresentation forKey:@"weixinInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:persistDic forKey:kSystemConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_sharedConfig != self) {
        _sharedConfig = self;
    }
}

- (Class)userNamesElementClass {
    return [YPBSystemConfig class];
}

- (NSDictionary *)vipPointDictionary {
    NSString *vipPointInfo = self.vipPointInfo;
    NSArray *vipPointArr = [vipPointInfo componentsSeparatedByString:@"|"];
    NSMutableDictionary *vipDic = [NSMutableDictionary dictionary];
    [vipPointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *vips = [obj componentsSeparatedByString:@":"];
        if (vips.count == 2) {
            [vipDic setObject:vips[0] forKey:vips[1]];
        }
    }];
    return vipDic.count > 0 ? vipDic : nil;
}
@end
