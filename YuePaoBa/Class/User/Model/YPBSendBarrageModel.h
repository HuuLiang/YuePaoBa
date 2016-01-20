//
//  YPBSendBarrageModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBSendBarrageModel : YPBEncryptedURLRequest

- (BOOL)sendBarrage:(NSString *)barrage forPhoto:(NSNumber *)photoId withCompletionHandler:(YPBCompletionHandler)handler;

@end
