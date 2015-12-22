//
//  YPBActivateModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/19.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBActivateResponse : YPBURLResponse
@property (nonatomic) NSString *uuid;
@end

@interface YPBActivateModel : YPBEncryptedURLRequest

@property (nonatomic,readonly) NSString *activationId;

+ (instancetype)sharedModel;

- (BOOL)requestActivationWithCompletionHandler:(YPBCompletionHandler)handler;

@end
