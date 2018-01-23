//
//  YPBUserVIPUpgradeModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBUserVIPUpgradeModel : YPBEncryptedURLRequest

+ (instancetype)sharedModel;
- (BOOL)upgradeToVIPWithExpireTime:(NSString *)expireTime
                 completionHandler:(YPBCompletionHandler)handler;
- (void)startRetryingToSynchronizeVIPInfos;

@end
