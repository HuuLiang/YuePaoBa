//
//  YPBFetchBarrageModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBBarrage.h"

@interface YPBFetchBarrageResponse : YPBURLResponse
@property (nonatomic,retain) NSArray<YPBBarrage *> *barrages;
@end

@interface YPBFetchBarrageModel : YPBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<YPBBarrage *> *fetchedBarrages;

- (BOOL)fetchBarragesById:(NSNumber *)barrageId barrageType:(YPBBarrageType)barrageType completionHandler:(YPBCompletionHandler)handler;

@end
