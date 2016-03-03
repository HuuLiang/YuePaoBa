//
//  YPBUserSentGiftsModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserSentGiftsModel.h"

@implementation YPBUserSentGiftsResponse

- (Class)giftsElementClass {
    return [YPBGift class];
}

@end

@implementation YPBUserSentGiftsModel

+ (Class)responseClass {
    return [YPBUserSentGiftsResponse class];
}

- (BOOL)fetchGiftsByUser:(NSString *)userId withCompletionHandler:(YPBCompletionHandler)handler {
    if (userId.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [self requestURLPath:YPB_USER_SENT_GIFTS_URL
                         withParams:@{@"userId":userId}
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        NSArray *gifts;
        if (respStatus == YPBURLResponseSuccess) {
            YPBUserSentGiftsResponse *resp = self.response;
            gifts = resp.gifts;
            self->_fetchedGifts = gifts;
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, gifts);
    }];
    return ret;
}

@end
