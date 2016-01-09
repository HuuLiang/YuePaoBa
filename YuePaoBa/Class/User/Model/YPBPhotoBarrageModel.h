//
//  YPBPhotoBarrageModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBPhotoBarrageResponse : YPBURLResponse
@property (nonatomic,retain) NSArray<NSString *> *data;
@end

@interface YPBPhotoBarrageModel : YPBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<NSString *> *fetchedBarrages;

- (BOOL)fetchBarrageWithPhotoId:(NSNumber *)photoId completionHandler:(YPBCompletionHandler)handler;

@end
