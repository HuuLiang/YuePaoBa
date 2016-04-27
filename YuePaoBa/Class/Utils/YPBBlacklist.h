//
//  YPBBlacklist.h
//  YuePaoBa
//
//  Created by Liang on 16/4/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBBlacklist : NSObject

@property (nonatomic,retain) NSMutableArray *array;

+ (instancetype)sharedInstance;

- (BOOL)checkUserIdIsTure:(NSString *)userid;

- (void)addUserIntoBlacklist:(NSString *)userid UserImage:(NSString *)imageUrl NickName:(NSString *)nickname;

- (void)cancleUserFromBlacklist:(NSString *)userid;

- (NSArray *)getAllUserInfo;

- (void)updateUserInfo:(NSArray *)array;

@end
