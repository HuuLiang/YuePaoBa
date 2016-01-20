//
//  YPBUserPhotoDeleteModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBUserPhotoDeleteModel : YPBEncryptedURLRequest

- (BOOL)deleteUserPhotoWithId:(NSNumber *)id completionHandler:(YPBCompletionHandler)handler;

@end
