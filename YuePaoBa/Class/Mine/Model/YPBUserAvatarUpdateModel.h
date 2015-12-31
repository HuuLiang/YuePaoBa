//
//  YPBUserAvatarUpdateModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBUserAvatarUpdateModel : YPBEncryptedURLRequest

- (BOOL)updateAvatarOfUser:(NSString *)userId
                   withURL:(NSString *)urlString
         completionHandler:(YPBCompletionHandler)handler;

@end
