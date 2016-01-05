//
//  YPBMessagePushModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBMessagePushModel.h"

@implementation YPBMessagePushModel

- (BOOL)fetchMessageWithUserId:(NSString *)userId
                      loginSeq:(NSUInteger)loginSeq
                 loginDuration:(NSUInteger)duration
             completionHandler:(YPBCompletionHandler)handler
{
    NSDictionary *params = @{@"userId":userId,
                             @"loginSeq":@(loginSeq),
                             @"duration":@(duration)};
    BOOL ret = [self requestURLPath:YPB_USER_MESSAGE_PUSH_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        
    }];
    return ret;
}
@end
