//
//  YPBUserPhotoAddModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBUserPhotoAddModel : YPBEncryptedURLRequest

- (BOOL)addOriginalPhotos:(NSArray<NSString *> *)originalPhotoUrls
              thumbPhotos:(NSArray<NSString *> *)thumbPhotoUrls
                   byUser:(NSString *)userId
    withCompletionHandler:(YPBCompletionHandler)handler;
@end
