//
//  YPBUserAccessModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"

typedef NS_ENUM(NSUInteger, YPBUserAccessType) {
    YPBUserAccessTypeUnknown,
    YPBUserAccessTypeGreet,
    YPBUserAccessTypeViewDetail
};

@interface YPBUserAccessModel : YPBEncryptedURLRequest

- (BOOL)accessUserWithUserId:(NSString *)userId
                  accessType:(YPBUserAccessType)accessType
           completionHandler:(YPBCompletionHandler)handler;
@end
