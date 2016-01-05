//
//  YPBMessagePushModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBMessagePushResponse : YPBURLResponse

@end

@interface YPBMessagePushModel : YPBEncryptedURLRequest

- (BOOL)fetchMessageWithUserId:(NSString *)userId
                      loginSeq:(NSUInteger)loginSeq
                 loginDuration:(NSUInteger)duration
             completionHandler:(YPBCompletionHandler)handler;

@end
