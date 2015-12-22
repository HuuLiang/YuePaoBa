//
//  YPBUtil.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBUtil : NSObject

+ (RESideMenu *)sideMenuViewController;

+ (NSString *)activationId;
+ (void)setActivationId:(NSString *)activationId;

+ (void)notifyRegisterSuccessfully;

+ (NSString *)deviceName;
+ (NSString *)appVersion;
+ (NSString *)appId;
+ (NSNumber *)pV;

@end
