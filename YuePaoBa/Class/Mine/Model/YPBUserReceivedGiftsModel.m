//
//  YPBUserReceivedGiftsModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserReceivedGiftsModel.h"

@implementation YPBUserReceivedGiftsResponse

- (Class)giftsElementClass {
    return [YPBGift class];
}

@end

@implementation YPBUserReceivedGiftsModel

+ (Class)responseClass {
    return [YPBUserReceivedGiftsResponse class];
}

- (BOOL)fetchGiftsByUser:(NSString *)userId withCompletionHandler:(YPBCompletionHandler)handler {
    if (userId.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [self requestURLPath:YPB_USER_RECEIVED_GIFTS_URL
                         withParams:@{@"userId":userId}
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        NSArray *gifts;
        if (respStatus == YPBURLResponseSuccess) {
            YPBUserReceivedGiftsResponse *resp = self.response;
            gifts = resp.gifts;
            self->_fetchedGifts = gifts;
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, gifts);
    }];
    return ret;
}

@end
