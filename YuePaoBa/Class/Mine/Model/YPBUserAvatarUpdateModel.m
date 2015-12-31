//
//  YPBUserAvatarUpdateModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserAvatarUpdateModel.h"

@implementation YPBUserAvatarUpdateModel

- (BOOL)updateAvatarOfUser:(NSString *)userId
                   withURL:(NSString *)urlString
         completionHandler:(YPBCompletionHandler)handler
{
    NSDictionary *params = @{@"userId":userId, @"logoUrl":urlString};
    BOOL ret = [self requestURLPath:YPB_USER_AVATAR_UPDATE_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
