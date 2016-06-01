//
//  YPBAccountCheck.h
//  YuePaoBa
//
//  Created by Liang on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBAccountCheck : NSObject

+ (BOOL)checkAccountInfoWithNickName:(NSString *)name Password:(NSString *)password;

+ (BOOL)checkAcountInfoWithId:(NSString *)userId Password:(NSString *)password;

@end
