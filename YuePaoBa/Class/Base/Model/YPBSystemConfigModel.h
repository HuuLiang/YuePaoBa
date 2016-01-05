//
//  YPBSystemConfigModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBSystemConfig.h"

@interface YPBSystemConfigResponse : YPBURLResponse
@property (nonatomic,retain) YPBSystemConfig *data;
@end

@interface YPBSystemConfigModel : YPBEncryptedURLRequest

@property (nonatomic,retain) YPBSystemConfig *fetchedSystemConfig;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(YPBCompletionHandler)handler;

@end
