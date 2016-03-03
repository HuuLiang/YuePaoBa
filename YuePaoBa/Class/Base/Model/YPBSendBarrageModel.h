//
//  YPBSendBarrageModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBBarrage.h"

@interface YPBSendBarrageModel : YPBEncryptedURLRequest

- (BOOL)sendBarrage:(NSString *)barrage
        forObjectId:(NSNumber *)objectId
        barrageType:(YPBBarrageType)barrageType
   barrageTimestamp:(NSNumber *)timestamp withCompletionHandler:(YPBCompletionHandler)handler;

@end
