//
//  YPBUserPhotoAddModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserPhotoAddModel.h"

@implementation YPBUserPhotoAddModel

- (BOOL)addOriginalPhotos:(NSArray<NSString *> *)originalPhotoUrls
              thumbPhotos:(NSArray<NSString *> *)thumbPhotoUrls
                   byUser:(NSString *)userId
    withCompletionHandler:(YPBCompletionHandler)handler {
    if (originalPhotoUrls.count != thumbPhotoUrls.count) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userId forKey:@"userId"];
    [params setObject:@(originalPhotoUrls.count) forKey:@"photoCount"];
    
    [originalPhotoUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *originalPhotoUrl = obj;
        NSString *thumbPhotoUrl = thumbPhotoUrls[idx];
        
        [params setObject:originalPhotoUrl forKey:[NSString stringWithFormat:@"bigPhoto%ld", idx+1]];
        [params setObject:thumbPhotoUrl forKey:[NSString stringWithFormat:@"smallPhoto%ld", idx+1]];
    }];
    
    BOOL ret = [self requestURLPath:YPB_USER_PHOTO_ADD_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus,
                                      NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}
@end
