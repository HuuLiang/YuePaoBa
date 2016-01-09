//
//  YPBFeedbackModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBFeedbackModel : YPBEncryptedURLRequest

- (BOOL)sendFeedback:(NSString *)content
              byUser:(NSString *)userId
withCompletionHandler:(YPBCompletionHandler)handler;

@end
