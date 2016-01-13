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
- (BOOL)upgradeToVIPWithMonths:(NSNumber *)months
                   upgradeTime:(NSString *)upgradeTime
             completionHandler:(YPBCompletionHandler)handler;
- (void)startRetryingToCommitUnprocessedVIPInfos;

@end
