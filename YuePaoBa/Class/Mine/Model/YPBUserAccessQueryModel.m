//
//  YPBUserAccessQueryModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserAccessQueryModel.h"

@implementation YPBUserAccess

- (Class)userGreetsElementClass {
    return [YPBUserGreet class];
}

@end

@implementation YPBUserAccessQueryModel

+ (Class)responseClass {
    return [YPBUserAccess class];
}

- (BOOL)queryUser:(NSString *)userId
   withAccessType:(YPBUserGetAccessType)accessType
        greetType:(YPBUserGreetingType)greetType
             page:(NSUInteger)page
completionHandler:(YPBCompletionHandler)handler
{
    @weakify(self);
    NSDictionary *params = @{@"userId":userId,
                             @"accessType":@(accessType),
                             @"greetType": greetType == YPBUserGreetingTypeSent ? @"send":@"receive",
                             @"pageNum":@(page),
                             @"pageSize":@10};
    BOOL ret = [self requestURLPath:YPB_USER_ACCESS_QUERY_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        NSArray *userGreets;
        if (respStatus == YPBURLResponseSuccess) {
            self.userAccess = self.response;
            userGreets = self.userAccess.userGreets;
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, userGreets);
    }];
    return ret;
}
@end
