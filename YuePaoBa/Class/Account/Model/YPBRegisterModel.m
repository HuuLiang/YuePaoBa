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
    if (user.logoUrl == nil) {
        user.logoUrl = @"";
    }
    if (user.age == nil) {
        user.age = @(18);
    }
    
    if (user.height == nil) {
        user.height = [NSNumber numberWithInt:160];
    }
    
    if (user.province == nil) {
        user.province = @"";
    }
    
    if (user.city == nil) {
        user.city = @"";
    }
    
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
             @"income":[NSNull null],
             @"bust":bust ?: @"",
             @"heightArea":heightArea,
             @"ageArea":ageArea,
             @"age":user.age,
             @"monthIncome":user.monthIncome,
             @"height":user.height,
             @"logoUrl":user.logoUrl,
             @"edu":user.edu,
             @"marry":user.marry,
             @"province":user.province,
             @"city":user.city};
    
}
@end
