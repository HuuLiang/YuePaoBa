//
//  YPBUserPhotoDeleteModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserPhotoDeleteModel.h"

@implementation YPBUserPhotoDeleteModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)deleteUserPhotoWithId:(NSNumber *)id completionHandler:(YPBCompletionHandler)handler {
    if (id == nil) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    BOOL ret = [self requestURLPath:YPB_USER_PHOTO_DELETE_URL
                         withParams:@{@"id":id}
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
