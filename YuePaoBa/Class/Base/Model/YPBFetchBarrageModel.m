//
//  YPBFetchBarrageModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBFetchBarrageModel.h"

@implementation YPBFetchBarrageResponse

- (Class)barragesElementClass {
    return [YPBBarrage class];
}
@end

@implementation YPBFetchBarrageModel

+ (Class)responseClass {
    return [YPBFetchBarrageResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchBarragesById:(NSNumber *)barrageId
              barrageType:(YPBBarrageType)barrageType
        completionHandler:(YPBCompletionHandler)handler
{
    if (!barrageId || barrageType == YPBBarrageTypeUnknown) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    @weakify(self);
    NSDictionary *params = @{@"objectType":@(barrageType), @"objectId":barrageId};
    BOOL ret = [self requestURLPath:YPB_FETCH_BARRAGES_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    
                    NSArray *barrages;
                    if (respStatus == YPBURLResponseSuccess) {
                        YPBFetchBarrageResponse *resp = self.response;
                        barrages = resp.barrages;
                        _fetchedBarrages = barrages;
                    }
                    
                    SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, barrages);
                }];
    return ret;
}
@end
