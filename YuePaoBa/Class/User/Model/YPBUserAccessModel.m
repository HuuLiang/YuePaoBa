//
//  YPBUserAccessModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserAccessModel.h"

@interface YPBUserAccessModel ()
@property (nonatomic) YPBUserAccessType accessType;
@end

@implementation YPBUserAccessModel

- (BOOL)shouldPostErrorNotification {
    if (self.accessType == YPBUserAccessTypeViewDetail) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)accessUserWithUserId:(NSString *)userId
                  accessType:(YPBUserAccessType)accessType
           completionHandler:(YPBCompletionHandler)handler {
    if (accessType == YPBUserAccessTypeUnknown) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    self.accessType = accessType;
    BOOL success = [self requestURLPath:YPB_USER_GREET_OR_VIEW_URL
                             withParams:@{@"greetUserId":[YPBUser currentUser].userId,
                                          @"receiveUserId":userId,
                                          @"accessType":@(accessType)}
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        NSUInteger greetCount = [YPBUser currentUser].greetCount.unsignedIntegerValue;
                        [YPBUser currentUser].greetCount = @(greetCount+1);
                        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, nil);
                    }];
    return success;
}

@end
