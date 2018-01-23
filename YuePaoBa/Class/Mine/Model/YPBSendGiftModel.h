//
//  YPBSendGiftModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBSendGiftModel : YPBEncryptedURLRequest

- (BOOL)sendGift:(NSNumber *)giftId toUser:(NSString *)userId withNickName:(NSString *)nickName completionHandler:(YPBCompletionHandler)handler;

@end
