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
    NSDictionary *params = [self paramsFromUser:user];
    BOOL success = [self requestURLPath:YPB_USER_REGISTER_URL
                             withParams:params
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        YPBRegisterResponse *resp = self.response;
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, resp.userId);
    }];
    return success;
}

- (NSDictionary *)paramsFromUser:(YPBUser *)user {
    NSString *bust;
    if (user.gender == YPBUserGenderMale) {
        switch (user.targetCup) {
            case YPBUserCupUnspecified:
                bust = @"0";
                break;
            case YPBUserCupA:
                bust = @"A";
                break;
            case YPBUserCupB:
                bust = @"B";
                break;
            case YPBUserCupC:
                bust = @"C";
                break;
            case YPBUserCupCPlus:
                bust = @"C+";
                break;
            default:
                break;
        }
    }
    
    NSString *heightArea = [NSString stringWithFormat:@"%ld~%ld", (long)user.targetHeight.min, (long)user.targetHeight.max];
    NSString *ageArea = [NSString stringWithFormat:@"%ld~%ld", (long)user.targetAge.min, (long)user.targetAge.max];
    return @{@"sex":user.sex,
             @"nickName":user.nickName,
             @"uuid":[YPBUtil activationId],
             @"logoUrl":user.logoUrl ?: @"",
             @"monthIncome":user.monthIncome,
             @"password":user.password ?: @"",
             @"height":user.height ?: @0,
             @"profession":user.profession ?: @"",
             @"city":user.city ?: @"",
             @"province":user.province ?: @"",
             @"openid":user.openid ?: @"",
             @"unionid":user.unionid ?: @"",
             @"bust":bust ?: @"",
             @"heightArea":heightArea,
             @"ageArea":ageArea,
             @"userType":user.password ? @2 : @3};
}

- (BOOL)requestAccountInfoWithUser:(YPBUser *)user withCompletionHandler:(YPBAccountComplttionHandler)handler {
    NSDictionary *params = @{@"userId":user.userId ?: @"",
                             @"password":user.password ?: @"",
                             @"userType":user.password ? @2 : @3,
                             @"opoenid":user.openid ?: @"",
                             @"unionid":user.unionid ?: @""};
    BOOL success = [self requestURLPath:YPB_USER_LOGIN_URL
                             withParams:params
                        responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        YPBRegisterResponse *resp = self.response;
                        
                        if (respStatus == YPBURLResponseSuccess) {
                            handler(respStatus == YPBURLResponseSuccess,resp.userId,resp.sex);
                        } else {
                            handler(respStatus == YPBURLResponseSuccess,resp.userId,resp.sex);
                        }
                    }];
    return success;
}
@end
