//
//  YPBGiftListModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBGiftListModel.h"

@implementation YPBGiftListResponse

- (Class)giftsElementClass {
    return [YPBGift class];
}
@end

@implementation YPBGiftListModel

+ (Class)responseClass {
    return [YPBGiftListResponse class];
}

- (BOOL)fetchGiftListWithCompletionHandler:(YPBCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:YPB_GIFT_LIST_URL
                         withParams:nil
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        NSArray<YPBGift *> *gifts;
        if (respStatus == YPBURLResponseSuccess) {
            YPBGiftListResponse *resp = self.response;
            gifts = resp.gifts;
            
            if (self) {
                self->_fetchedGifts = gifts;
            }
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, gifts);
    }];
    return ret;
}

@end
