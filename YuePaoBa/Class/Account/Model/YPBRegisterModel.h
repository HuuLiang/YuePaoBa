//
//  YPBRegisterModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBRegisterResponse : YPBURLResponse
@property (nonatomic) NSString *userId;
@end

@interface YPBRegisterModel : YPBEncryptedURLRequest

- (BOOL)requestRegisterUser:(YPBUser *)user withCompletionHandler:(YPBCompletionHandler)handler;

@end
