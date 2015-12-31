//
//  YPBUserDetailUpdateModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/30.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserDetailUpdateModel.h"

@implementation YPBUserDetailUpdateModel

- (BOOL)updateDetailOfUser:(YPBUser *)user withCompletionHandler:(YPBCompletionHandler)handler {
    NSDictionary *params = @{@"userId":user.userId,
                             @"age":user.age,
                             @"height":user.height,
                             @"logoUrl":user.logoUrl,
                             @"nickName":user.nickName,
                             @"note":user.note,
                             @"profession":user.profession,
                             @"bwh":user.bwh,
                             @"monthIncome":user.monthIncome,
                             @"assets":user.assets,
                             @"weixinNum":user.weixinNum };
    
    BOOL ret = [self requestURLPath:YPB_USER_DETAIL_UPDATE_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        BOOL success = respStatus == YPBURLResponseSuccess;
        SafelyCallBlock2(handler, success, success ? user : nil);
    }];
    return ret;
}

@end
