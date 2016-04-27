//
//  YPBReportViolationModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBReportViolationModel.h"

@implementation YPBReportViolationModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)reportViolationWithContent:(NSString *)content
                            userId:(NSString *)userId
                 completionHandler:(YPBCompletionHandler)handler {
    if (![YPBUser currentUser].isRegistered || content.length == 0 || userId.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSDictionary *params = @{@"userId":[YPBUser currentUser].userId,
                             @"reportUserId":userId,
                             @"content":content};
    BOOL ret = [self requestURLPath:YPB_REPORT_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
