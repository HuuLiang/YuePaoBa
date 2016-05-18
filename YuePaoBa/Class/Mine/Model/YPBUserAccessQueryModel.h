//
//  YPBUserAccessQueryModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBUserGreet.h"

typedef NS_ENUM(NSUInteger, YPBUserGetAccessType) {
    YPBUserGetAccessTypeUnknown,
    YPBUserGetAccessTypeGreeting,
    YPBUserGetAccessTypeViewing
};

typedef NS_ENUM(NSUInteger, YPBUserGreetingType) {
    YPBUserGreetingTypeSent,
    YPBUserGreetingTypeReceived
};

@interface YPBUserAccess : YPBURLResponse

@property (nonatomic,retain) NSArray<YPBUserGreet *> *userGreets;

@end

@interface YPBUserAccessQueryModel : YPBEncryptedURLRequest

@property (nonatomic,retain) YPBUserAccess *userAccess;

- (BOOL)queryUser:(NSString *)userId
   withAccessType:(YPBUserGetAccessType)accessType
        greetType:(YPBUserGreetingType)greetType
             page:(NSUInteger)page
completionHandler:(YPBCompletionHandler)handler;

@end
