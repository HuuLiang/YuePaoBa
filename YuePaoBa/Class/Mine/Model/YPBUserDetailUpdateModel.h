//
//  YPBUserDetailUpdateModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/30.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBUserDetailUpdateModel : YPBEncryptedURLRequest

- (BOOL)updateDetailOfUser:(YPBUser *)user withCompletionHandler:(YPBCompletionHandler)handler;

- (BOOL)updateUserPhoneWithUserID:(NSString *)userId Phone:(NSString *)phone withCompletionHandler:(YPBCompletionHandler)handler;

@end
