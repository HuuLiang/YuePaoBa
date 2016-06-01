//
//  YPBAccountCheck.m
//  YuePaoBa
//
//  Created by Liang on 16/6/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBAccountCheck.h"

@implementation YPBAccountCheck

+ (BOOL)checkAccountInfoWithNickName:(NSString *)name Password:(NSString *)password {
    if (name.length == 0) {
        YPBShowWarning(@"请输入昵称");
        return NO;
    } else if (name.length < 2) {
        YPBShowWarning(@"您输入的昵称太短了哦");
        return NO;
    } else if (name.length > 12) {
        YPBShowWarning(@"您输入的昵称太长了哦");
        return NO;
    }
    if (![self checkPassword:password]) {
        return NO;
    }

    return YES;
}

+ (BOOL)checkAcountInfoWithId:(NSString *)userId Password:(NSString *)password {
    if (!(userId.length == 8 || userId.length == 7)) {
        YPBShowWarning(@"用户ID不符合要求哦");
        return NO;
    }
    
    NSString *pattern = @"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL ismatch = [pred evaluateWithObject:userId];
    if (!ismatch) {
        YPBShowWarning(@"用户ID不符合要求哦");
        return NO;
    }

    
    if (![self checkPassword:password]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkPassword:(NSString *)password {
    if (password.length == 0) {
        YPBShowWarning(@"请输入密码");
        return NO;
    } else if (password.length < 6) {
        YPBShowWarning(@"您输入的密码太短了哦");
        return NO;
    } else if (password.length > 16) {
        YPBShowWarning(@"您输入的密码太长了哦");
        return NO;
    }
    
    NSString *pattern = @"^[A-Za-z0-9_]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL ismatch = [pred evaluateWithObject:password];
    if (!ismatch) {
        YPBShowWarning(@"密码不符合要求哦");
        return NO;
    }
    return YES;
}

@end
