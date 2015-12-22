//
//  YPBRegisterModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBRegisterModel.h"

@implementation YPBRegisterResponse

@end

@implementation YPBRegisterModel

+ (Class)responseClass {
    return [YPBRegisterResponse class];
}

- (BOOL)requestRegisterUser:(YPBUser *)user withCompletionHandler:(YPBCompletionHandler)handler {
    BOOL success = [self requestURLPath:YPB_USER_REGISTER_URL
                             withParams:[self paramsFromUser:user]
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YPBRegisterResponse *resp = self.response;
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, resp.userId);
    }];
    return success;
}

- (NSDictionary *)paramsFromUser:(YPBUser *)user {
    NSString *bust;
    switch (user.targetCup) {
        case YPBTargetCupUnlimited:
            bust = @"0";
            break;
        case YPBTargetCupA:
            bust = @"A";
            break;
        case YPBTargetCupB:
            bust = @"B";
            break;
        case YPBTargetCupC:
            bust = @"C";
            break;
        case YPBTargetCupCPlus:
            bust = @"C+";
            break;
        default:
            break;
    }
    
    NSString *heightArea = [NSString stringWithFormat:@"%ld~%ld", user.targetHeight.min, user.targetHeight.max];
    NSString *ageArea = [NSString stringWithFormat:@"%ld~%ld", user.targetAge.min, user.targetAge.max];
    return @{@"sex":user.sex,
             @"nickName":user.nickName,
             @"uuid":[YPBUtil activationId],
             @"income":[NSNull null],
             @"bust":bust,
             @"heightArea":heightArea,
             @"ageArea":ageArea};
}
@end
