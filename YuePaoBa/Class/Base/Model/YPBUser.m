//
//  YPBUser.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUser.h"

NSString *const kNotLimitedDescription = @"不限";
static NSString *const kHeightUnitString = @"cm";
static NSString *const kAgeUnitString = @"岁";
static YPBUser *_currentUser;

@implementation YPBUserPhoto

@end

@interface YPBUser ()
@property (nonatomic) NSString *name;

- (instancetype)initFromUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)userInfo;
@end

@implementation YPBUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKeyName];
        _currentUser = [[self alloc] initFromUserInfo:userInfo];
    });
    return _currentUser;
}

+ (NSArray<NSString *> *)allCupsDescription {
    return @[kNotLimitedDescription,@"A罩杯",@"B罩杯",@"C罩杯",@"C罩杯以上"];
}

+ (NSArray<NSNumber *> *)allHeightValues {
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (NSUInteger i = 0; i < 20; ++i) {
        [values addObject:@(140+i*5)];
    }
    return values;
}

+ (NSArray<NSNumber *> *)allAgeValues {
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (NSUInteger i = 0; i < 60; ++i) {
        [values addObject:@(18+i)];
    }
    return values;
}

+ (NSArray<NSString *> *)allHeightRangeDescription {
    NSMutableArray *heightStrings = [NSMutableArray array];
    
    [self.allHeightValues enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToNumber:@(0)]) {
            [heightStrings addObject:kNotLimitedDescription];
        } else {
            [heightStrings addObject:[obj.stringValue stringByAppendingString:kHeightUnitString]];
        }
    }];

    return heightStrings;
}

+ (NSArray<NSString *> *)allAgeRangeDescription {
    NSMutableArray *ageStrings = [NSMutableArray array];
    
    [self.allAgeValues enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToNumber:@(0)]) {
            [ageStrings addObject:kNotLimitedDescription];
        } else {
            [ageStrings addObject:[obj.stringValue stringByAppendingString:kAgeUnitString]];
        }
    }];
    return ageStrings;
}

+ (YPBUserGender)genderFromString:(NSString *)genderString {
    if ([genderString isEqualToString:@"M"]) {
        return YPBUserGenderMale;
    } else if ([genderString isEqualToString:@"F"]) {
        return YPBUserGenderFemale;
    } else {
        return YPBUserGenderUnknown;
    }
}

+ (NSString *)stringOfGender:(YPBUserGender)gender {
    if (gender == YPBUserGenderMale) {
        return @"M";
    } else if (gender == YPBUserGenderFemale) {
        return @"F";
    } else {
        return nil;
    }
}

- (Class)userPhotosElementClass {
    return [YPBUserPhoto class];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _targetCup = YPBTargetCupCPlus;
        
        YPBIntRange heightRange;
        heightRange.min = 155;
        heightRange.max = 165;
        _targetHeight = heightRange;
        
        YPBIntRange ageRange;
        ageRange.min = 18;
        ageRange.max = 25;
        _targetAge = ageRange;
    }
    return self;
}

- (instancetype)initFromUserInfo:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        _userId = userInfo[kUserIDKeyName];
        _gender = ((NSNumber *)userInfo[kUserGenderKeyName]).unsignedIntegerValue;
        _nickName = userInfo[kUserNicknameKeyName];
        _targetCup = ((NSNumber *)userInfo[kUserTargetCupKeyName]).unsignedIntegerValue;
        
        NSArray *targetHeight = userInfo[kUserTargetHeightRangeKeyName];
        if (targetHeight.count == 2) {
            _targetHeight.min = ((NSNumber *)targetHeight[0]).floatValue;
            _targetHeight.max = ((NSNumber *)targetHeight[1]).floatValue;
        } else {
            _targetHeight.min = 155;
            _targetHeight.max = 170;
        }
        
        NSArray *targetAge = userInfo[kUserTargetAgeRangeKeyName];
        if (targetAge.count == 2) {
            _targetAge.min = ((NSNumber *)targetAge[0]).floatValue;
            _targetAge.max = ((NSNumber *)targetAge[1]).floatValue;
        } else {
            _targetAge.min = 18;
            _targetAge.max = 25;
        }
    }
    return self;
}

- (NSDictionary *)userInfo {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo safely_setObject:self.userId forKey:kUserIDKeyName];
    [userInfo safely_setInteger:self.gender forKey:kUserGenderKeyName];
    [userInfo safely_setObject:self.nickName forKey:kUserNicknameKeyName];
    [userInfo safely_setInteger:self.targetCup forKey:kUserTargetCupKeyName];
    
    [userInfo safely_setObject:@[@(self.targetHeight.min),@(self.targetHeight.max)] forKey:kUserTargetHeightRangeKeyName];
    [userInfo safely_setObject:@[@(self.targetAge.min),@(self.targetAge.max)] forKey:kUserTargetAgeRangeKeyName];
    return userInfo;
}

- (BOOL)isRegistered {
    return self.userId.length > 0;
}

- (void)setAsCurrentUser {
    if (_currentUser == self) {
        return;
    }
    
    _currentUser = self;
    [[NSUserDefaults standardUserDefaults] setObject:self.userInfo forKey:kUserInfoKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentUserChangeNotification object:nil];
}

- (NSError *)validate {
    if (_nickName.length == 0 || [_nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return [NSError errorWithDomain:kUserInfoValidationErrorDomain code:kNicknameEmptyErrorCode userInfo:@{kErrorMessageKeyName:@"昵称不能为空"}];
    }
    return nil;
}

- (NSString *)filterRangeBetween:(NSString *)value1 and:(NSString *)value2 {
    NSString *value;
    if ([value1 isEqualToString:kNotLimitedDescription] && [value2 isEqualToString:kNotLimitedDescription]) {
        value = kNotLimitedDescription;
    } else if ([value1 isEqualToString:kNotLimitedDescription]) {
        value = [NSString stringWithFormat:@"%@以下", value2];
    } else if ([value2 isEqualToString:kNotLimitedDescription]) {
        value = [NSString stringWithFormat:@"%@以上", value1];
    } else if ([value1 isEqualToString:value2]) {
        value = value1;
    } else {
        value = [NSString stringWithFormat:@"%@ ~ %@", value1, value2];
    }
    return value;
}

- (NSString *)targetHeightDescription {
    NSString *value1 = self.targetHeight.min == 0 ? kNotLimitedDescription : [NSString stringWithFormat:@"%ldcm", self.targetHeight.min];
    NSString *value2 = self.targetHeight.max == 0 ? kNotLimitedDescription : [NSString stringWithFormat:@"%ldcm", self.targetHeight.max];
    return [self filterRangeBetween:value1 and:value2];
}

- (NSString *)targetAgeDescription {
    NSString *value1 = self.targetAge.min == 0 ? kNotLimitedDescription : [NSString stringWithFormat:@"%ld岁", self.targetAge.min];
    NSString *value2 = self.targetAge.max == 0 ? kNotLimitedDescription : [NSString stringWithFormat:@"%ld岁", self.targetAge.max];
    return [self filterRangeBetween:value1 and:value2];
}

- (NSString *)targetCupDescription {
    return [[self class] allCupsDescription][self.targetCup];
}

- (void)setSex:(NSString *)sex {
    self.gender = [[self class] genderFromString:sex];
}

- (NSString *)sex {
    return [[self class] stringOfGender:self.gender];
}
@end
