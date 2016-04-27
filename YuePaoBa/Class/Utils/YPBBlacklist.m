//
//  YPBBlacklist.m
//  YuePaoBa
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBlacklist.h"

@interface YPBBlacklist ()


@property (nonatomic,copy) NSString *plistPath;

@end

@implementation YPBBlacklist

DefineLazyPropertyInitialization(NSMutableArray, array);

+ (instancetype)sharedInstance {
    static YPBBlacklist *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YPBBlacklist alloc] init];
    });
    return _sharedInstance;
}

- (BOOL)checkUserIdIsTure:(NSString *)userid{
    //获取沙盒路径下的documents文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docuPath = [paths objectAtIndex:0];
    
    //判断路径是否存在
    if (!_plistPath) {
        _plistPath = [NSString stringWithFormat:@"%@/Blacklist.plist",docuPath];
    }
    DLog("%@",_plistPath);
    //判断文件是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL ret = [fm fileExistsAtPath:_plistPath];
    if (!ret) {
        [fm createFileAtPath:_plistPath contents:nil attributes:nil];
        return NO;
    }
    
    //判断数组是否存在
    if (!_array) {
        [YPBBlacklist sharedInstance].array = [[NSMutableArray alloc] init];
        [YPBBlacklist sharedInstance].array = [NSMutableArray arrayWithContentsOfFile:_plistPath];
    } else {
        [[YPBBlacklist sharedInstance].array removeAllObjects];
        [YPBBlacklist sharedInstance].array = [NSMutableArray arrayWithContentsOfFile:_plistPath];
    }
    
    if (!userid) {
        return NO;
    }

    for (NSDictionary *aUser in [YPBBlacklist sharedInstance].array) {
        if ([aUser[@"userId"] isEqualToString:userid]) {
            return YES;
        }
    }

    return NO;
}


- (void)addUserIntoBlacklist:(NSString *)userid UserImage:(NSString *)imageUrl NickName:(NSString *)nickname{
    
    NSDictionary *params = @{@"userId":userid,
                             @"logoUrl":imageUrl,
                             @"nickname":nickname,
                             @"date":[self getCurrentTimeString]};
    [[YPBBlacklist sharedInstance].array addObject:params];
    [[YPBBlacklist sharedInstance].array writeToFile:_plistPath atomically:YES];
    DLog("%@",[YPBBlacklist sharedInstance].array);
}

- (void)cancleUserFromBlacklist:(NSString *)userid{
    for (NSDictionary *aUser in [YPBBlacklist sharedInstance].array) {
        if ([aUser[@"userId"] isEqualToString:userid]) {
            [[YPBBlacklist sharedInstance].array removeObject:aUser];
            break;
        }
    }
    [[YPBBlacklist sharedInstance].array writeToFile:_plistPath atomically:YES];
}

- (NSArray *)getAllUserInfo {
    BOOL ret = [self checkUserIdIsTure:nil];
    if (!ret) {
        return [YPBBlacklist sharedInstance].array;
    }
    return nil;
}

- (void)updateUserInfo:(NSArray *)array {
    [array writeToFile:_plistPath atomically:YES];
}

- (NSString*)getCurrentTimeString {
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy年MM月dd日HH:mm:ss"];
    NSString *dateStr = [dateformat stringFromDate:[NSDate date]];
    return dateStr;
}

@end
