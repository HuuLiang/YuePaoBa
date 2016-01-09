//
//  YPBPhotoBarrageModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPhotoBarrageModel.h"

@implementation YPBPhotoBarrageResponse

- (Class)dataElementClass {
    return [NSString class];
}

@end

@implementation YPBPhotoBarrageModel

+ (Class)responseClass {
    return [YPBPhotoBarrageResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchBarrageWithPhotoId:(NSNumber *)photoId
              completionHandler:(YPBCompletionHandler)handler
{
    if (!photoId) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    @weakify(self);
    NSDictionary *params = @{@"objectType":@"1", @"objectId":photoId};
    BOOL ret = [self requestURLPath:YPB_PHOTO_BARRAGE_QUERY_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        NSArray *barrages;
        if (respStatus == YPBURLResponseSuccess) {
            YPBPhotoBarrageResponse *resp = self.response;
            barrages = resp.data;
            _fetchedBarrages = barrages;
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, barrages);
    }];
    return ret;
}

@end
