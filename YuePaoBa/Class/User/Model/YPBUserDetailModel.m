//
//  YPBUserDetailModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserDetailModel.h"

@implementation YPBUserDetailResponse

- (Class)userInfoClass {
    return [YPBUser class];
}
@end

@implementation YPBUserDetailModel

+ (instancetype)sharedModel {
    static YPBUserDetailModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YPBUserDetailModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [YPBUserDetailResponse class];
}

- (BOOL)fetchUserDetailWithUserId:(NSString *)userId completionHandler:(YPBCompletionHandler)handler {
    if (userId.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    BOOL success = [self requestURLPath:YPB_USER_DETAIL_URL
                             withParams:@{@"userId":userId}
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YPBUserDetailResponse *resp = self.response;
        if (respStatus == YPBURLResponseSuccess) {
            _fetchedUser = resp.userInfo;
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, resp.userInfo);
    }];
    return success;
}

@end
