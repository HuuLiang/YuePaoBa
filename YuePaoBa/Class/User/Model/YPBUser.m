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

- (id)copyWithZone:(NSZone *)zone {
    YPBUserPhoto *copiedPhoto = [[self class] allocWithZone:zone];
    copiedPhoto.userId = [self.userId copyWithZone:zone];
    copiedPhoto.smallPhoto = [self.smallPhoto copyWithZone:zone];
    copiedPhoto.bigPhoto = [self.bigPhoto copyWithZone:zone];
    copiedPhoto.sort = [self.sort copyWithZone:zone];
    return copiedPhoto;
}

@end

@interface YPBUser ()
@property (nonatomic) NSString *name;

- (instancetype)initFromUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)userInfo;
@end

@implementation YPBUser

- (id)copyWithZone:(NSZone *)zone {
    YPBUser *copiedUser = [[self class] allocWithZone:zone];
    copiedUser.name = [self.name copyWithZone:zone];
    copiedUser.userId = [self.userId copyWithZone:zone];
    copiedUser.uuid = [self.uuid copyWithZone:zone];
    copiedUser.nickName = [self.nickName copyWithZone:zone];
    copiedUser.logoUrl = [self.logoUrl copyWithZone:zone];
    copiedUser.sex = [self.sex copyWithZone:zone];
    
    copiedUser.age = [self.age copyWithZone:zone];
    copiedUser.height = [self.height copyWithZone:zone];
    copiedUser.bwh = [self.bwh copyWithZone:zone];
    copiedUser.monthIncome = [self.monthIncome copyWithZone:zone];
    copiedUser.note = [self.note copyWithZone:zone];
    copiedUser.profession = [self.profession copyWithZone:zone];
    copiedUser.weixinNum = [self.weixinNum copyWithZone:zone];
    copiedUser.assets = [self.assets copyWithZone:zone];
    
    copiedUser.isMember = self.isMember;
    copiedUser.isVip = self.isVip;
    
    copiedUser.memberEndTime = [self.memberEndTime copyWithZone:zone];
    copiedUser.vipEndTime = [self.vipEndTime copyWithZone:zone];
    
    copiedUser.greetCount = [self.greetCount copyWithZone:zone];
    copiedUser.accessCount = [self.accessCount copyWithZone:zone];
    copiedUser.receiveGreetCount = [self.receiveGreetCount copyWithZone:zone];
    copiedUser.userPhotos = [[NSArray alloc] initWithArray:self.userPhotos copyItems:YES];
    
    copiedUser.gender = self.gender;
    copiedUser.targetHeight = self.targetHeight;
    copiedUser.targetAge = self.targetAge;
    copiedUser.targetCup = self.targetCup;
    
    return copiedUser;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (self.userId == nil) {
        return NO;
    }
    
    return [self.userId isEqualToString:((YPBUser *)object).userId];
}

- (NSUInteger)hash {
    return self.userId.hash;
}

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKeyName];
        _currentUser = [[self alloc] initFromUserInfo:userInfo];
    });
    return _currentUser;
}

+ (NSArray<NSString *> *)allTargetCupsDescription {
    NSMutableArray *arr = [self allCupsDescription].mutableCopy;
    arr[0] = kNotLimitedDescription;
    return arr;
}

+ (NSArray<NSString *> *)allCupsDescription {
    return @[@"", @"A罩杯",@"B罩杯",@"C罩杯",@"C罩杯以上"];
}

+ (NSArray<NSNumber *> *)allHeightRangeValues {
    YPBIntRange heightRange = self.availableHeightRange;
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (NSUInteger i = heightRange.min; i < heightRange.max+1; ++i) {
        [values addObject:@(i)];
    }
    return values;
}

+ (NSArray<NSNumber *> *)allAgeValues {
    YPBIntRange ageRange = self.availableAgeRange;
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (NSUInteger i = ageRange.min; i < ageRange.max+1; ++i) {
        [values addObject:@(i)];
    }
    return values;
}

+ (NSArray<NSNumber *> *)allBustValues {
    YPBFloatRange bustRange = self.availableBustRange;
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (CGFloat i = bustRange.min; i < bustRange.max+0.5; i+=0.5) {
        [values addObject:@(i)];
    }
    return values;
}

+ (NSArray<NSString *> *)allHeightRangeDescription {
    NSMutableArray *heightStrings = [NSMutableArray array];
    
    [self.allHeightRangeValues enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

+ (NSArray<NSNumber *> *)allWeightRangeValues {
    NSMutableArray *values = [NSMutableArray array];
    YPBFloatRange weightRange = [self availableWeightRange];
    for (CGFloat i = weightRange.min; i < weightRange.max+0.5; i+=0.5) {
        [values addObject:@(i)];
    }
    return values;
}

+ (YPBIntRange)availableHeightRange {
    YPBIntRange heightRange = {140,220};
    return heightRange;
}

+ (YPBIntRange)availableAgeRange {
    YPBIntRange ageRange = {18,45};
    return ageRange;
}

+ (YPBFloatRange)availableWeightRange {
    YPBFloatRange weightRange = {40,125};
    return weightRange;
}

+ (YPBFloatRange)availableBustRange {
    YPBFloatRange bustRange = {60,120};
    return bustRange;
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
        _targetCup = YPBUserCupCPlus;
        
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
    
//    @property (nonatomic) NSString *userId;
//    @property (nonatomic) NSString *uuid; //激活码
//    @property (nonatomic) NSString *nickName;
//    @property (nonatomic) NSString *logoUrl;
//    @property (nonatomic) NSString *sex;
//    
//    @property (nonatomic) NSNumber *age;
//    @property (nonatomic) NSNumber *height;
//    @property (nonatomic) NSString *bwh; // 身材
//    @property (nonatomic) NSString *monthIncome;
//    @property (nonatomic) NSString *note; // 兴趣
//    @property (nonatomic) NSString *profession;
//    @property (nonatomic) NSString *weixinNum;
//    @property (nonatomic) NSString *assets;
//    
//    @property (nonatomic) BOOL isMember;
//    @property (nonatomic) BOOL isVip;
//    
//    @property (nonatomic) NSString *memberEndTime;
//    @property (nonatomic) NSString *vipEndTime;
//    
//    @property (nonatomic) NSNumber *greetCount;
//    @property (nonatomic) NSNumber *accessCount;
//    @property (nonatomic) NSNumber *receiveGreetCount;
//    @property (nonatomic) NSArray<YPBUserPhoto *> *userPhotos;
    self = [super init];
    if (self) {
        _userId            = userInfo[kUserIDKeyName];
        _gender            = ((NSNumber *)userInfo[kUserGenderKeyName]).unsignedIntegerValue;
        _nickName          = userInfo[kUserNicknameKeyName];
        _logoUrl           = userInfo[kUserLogoKeyName];
        _age               = userInfo[kUserAgeKeyName];
        _height            = userInfo[kUserHeightKeyName];
        _bwh               = userInfo[kUserFigureKeyName];
        _monthIncome       = userInfo[kUserIncomeKeyName];
        _note              = userInfo[kUserInterestKeyName];
        _profession        = userInfo[kUserProfessionKeyName];
        _weixinNum         = userInfo[kUserWeChatKeyName];
        _assets            = userInfo[kUserAssetsKeyName];

        _isMember          = ((NSNumber *)userInfo[kUserIsMemberKeyName]).boolValue;
        _isVip             = ((NSNumber *)userInfo[kUserIsVIPKeyName]).boolValue;

        _memberEndTime     = userInfo[kUserMemberEndTimeKeyName];
        _vipEndTime        = userInfo[kUserVIPEndTimeKeyName];

        _greetCount        = userInfo[kUserGreetCountKeyName];
        _receiveGreetCount = userInfo[kUserReceiveGreetCountKeyName];
        _accessCount       = userInfo[kUserAccessCountKeyName];
        
        // Target
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
    [userInfo safely_setObject:self.logoUrl forKey:kUserLogoKeyName];
    [userInfo safely_setObject:self.age forKey:kUserAgeKeyName];
    [userInfo safely_setObject:self.height forKey:kUserHeightKeyName];
    [userInfo safely_setObject:self.bwh forKey:kUserFigureKeyName];
    [userInfo safely_setObject:self.monthIncome forKey:kUserIncomeKeyName];
    [userInfo safely_setObject:self.note forKey:kUserInterestKeyName];
    [userInfo safely_setObject:self.profession forKey:kUserProfessionKeyName];
    [userInfo safely_setObject:self.weixinNum forKey:kUserWeChatKeyName];
    [userInfo safely_setObject:self.assets forKey:kUserAssetsKeyName];
    
    [userInfo setObject:@(self.isMember) forKey:kUserIsMemberKeyName];
    [userInfo setObject:@(self.isVip) forKey:kUserIsVIPKeyName];
    
    [userInfo safely_setObject:self.memberEndTime forKey:kUserMemberEndTimeKeyName];
    [userInfo safely_setObject:self.vipEndTime forKey:kUserVIPEndTimeKeyName];
    
    [userInfo safely_setObject:self.greetCount forKey:kUserGreetCountKeyName];
    [userInfo safely_setObject:self.receiveGreetCount forKey:kUserReceiveGreetCountKeyName];
    [userInfo safely_setObject:self.accessCount forKey:kUserAccessCountKeyName];
    
    //Target
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

- (NSString *)heightDescription {
    return self.height.unsignedIntegerValue > 0 ? [NSString stringWithFormat:@"%@ cm", self.height] : nil;
}

- (NSString *)ageDescription {
    return self.age.unsignedIntegerValue > 0 ? [NSString stringWithFormat:@"%@岁", self.age] : nil;
}

- (NSString *)weightDescription {
    return self.weight > 0 ? [NSString stringWithFormat:@"%.1f kg", self.weight] : nil;
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
    return [[self class] allTargetCupsDescription][self.targetCup];
}

- (void)setSex:(NSString *)sex {
    self.gender = [[self class] genderFromString:sex];
}

- (NSString *)sex {
    return [[self class] stringOfGender:self.gender];
}

- (void)setWeight:(CGFloat)weight {
    if (self.gender == YPBUserGenderMale) {
        self.bwh = [NSString stringWithFormat:@"%.1f", weight];
    }
}

- (CGFloat)weight {
    if (self.gender == YPBUserGenderMale) {
        return self.bwh.floatValue;
    } else {
        return 0;
    }
}

- (CGFloat)bust {
    NSArray<NSString *> *bwh = [self.bwh componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (bwh.count > 0) {
        return bwh[0].floatValue;
    }
    return 0;
}

- (CGFloat)waist {
    NSArray<NSString *> *bwh = [self.bwh componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (bwh.count > 1) {
        return bwh[1].floatValue;
    }
    return 0;
}

- (CGFloat)hip {
    NSArray<NSString *> *bwh = [self.bwh componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (bwh.count > 2) {
        return bwh[2].floatValue;
    }
    return 0;
}

- (YPBUserCup)cup {
    NSArray<NSString *> *bwh = [self.bwh componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (bwh.count > 3) {
        NSUInteger index = [[[self class] allCupsDescription] indexOfObject:bwh[3]];
        if (index != NSNotFound) {
            return index;
        }
    }
    return YPBUserCupUnspecified;
}

- (YPBUserGender)oppositeGender {
    if (self.gender == YPBUserGenderMale) {
        return YPBUserGenderFemale;
    } else if (self.gender == YPBUserGenderFemale) {
        return YPBUserGenderMale;
    } else {
        return YPBUserGenderUnknown;
    }
}
@end
