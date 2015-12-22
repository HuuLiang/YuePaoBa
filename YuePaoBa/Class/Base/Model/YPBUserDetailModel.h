//
//  YPBUserDetailModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

@interface YPBUserDetailResponse : YPBURLResponse
@property (nonatomic,retain) YPBUser *userInfo;
@end

@interface YPBUserDetailModel : YPBEncryptedURLRequest

+ (instancetype)sharedModel;
- (BOOL)fetchUserDetailWithUserId:(NSString *)userId completionHandler:(YPBCompletionHandler)handler;

@end
