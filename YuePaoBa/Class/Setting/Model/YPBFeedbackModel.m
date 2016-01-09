//
//  YPBFeedbackModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBFeedbackModel.h"

@implementation YPBFeedbackModel

- (BOOL)sendFeedback:(NSString *)content
              byUser:(NSString *)userId
withCompletionHandler:(YPBCompletionHandler)handler {
    if (userId.length == 0 || content.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    return [self requestURLPath:YPB_FEEDBACK_URL
                     withParams:NSDictionaryOfVariableBindings(userId,content)
                responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
}
@end
