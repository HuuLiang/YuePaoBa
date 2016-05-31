//
//  YPBUser.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUser.h"

NSString *const kNotLimitedDescription = @"不限";
NSString *const kSecretDescription = @"保密";
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
    copiedPhoto.id = [self.id copyWithZone:zone];
    return copiedPhoto;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safely_setObject:self.userId forKey:@"userId"];
    [dic safely_setObject:self.smallPhoto forKey:@"smallPhoto"];
    [dic safely_setObject:self.bigPhoto forKey:@"bigPhoto"];
    [dic safely_setObject:self.sort forKey:@"sort"];
    [dic safely_setObject:self.id forKey:@"id"];
    return dic;
}

- (instancetype)initFromDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.userId = dic[@"userId"];
        self.smallPhoto = dic[@"smallPhoto"];
        self.bigPhoto = dic[@"bigPhoto"];
        self.sort = dic[@"sort"];
        self.id = dic[@"id"];
    }
    return self;
}

+ (NSArray<YPBUserPhoto *> *)userPhotosFromArray:(NSArray<NSDictionary *> *)arr {
    NSMutableArray<YPBUserPhoto *> *userPhotos = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YPBUserPhoto *userPhoto = [[self alloc] initFromDictionary:obj];
        [userPhotos addObject:userPhoto];
    }];
    return userPhotos.count > 0 ? userPhotos : nil;
}

+ (NSArray<NSDictionary *> *)dictionariesFromUserPhotos:(NSArray<YPBUserPhoto *> *)userPhotos {
    NSMutableArray<NSDictionary *> *arr = [NSMutableArray array];
    [userPhotos enumerateObjectsUsingBlock:^(YPBUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj.dictionaryRepresentation];
    }];
    return arr.count > 0 ? arr : nil;
}
@end

@implementation YPBUserVideo

- (id)copyWithZone:(NSZone *)zone {
    YPBUserVideo *copiedVideo = [[self class] allocWithZone:zone];
    copiedVideo.imgCover = [self.imgCover copyWithZone:zone];
    copiedVideo.videoUrl = [self.videoUrl copyWithZone:zone];
    return copiedVideo;
}
@end

@implementation YPBGift

- (id)copyWithZone:(NSZone *)zone {
    YPBGift *gift = [[self class] allocWithZone:zone];
    gift.id = [self.id copyWithZone:zone];
    gift.name = [self.name copyWithZone:zone];
    gift.imgUrl = [self.imgUrl copyWithZone:zone];
    gift.fee = [self.fee copyWithZone:zone];
    gift.userName = [self.userName copyWithZone:zone];
    return gift;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safely_setObject:self.id forKey:@"id"];
    [dic safely_setObject:self.name forKey:@"name"];
    [dic safely_setObject:self.imgUrl forKey:@"imgUrl"];
    [dic safely_setObject:self.fee forKey:@"fee"];
    [dic safely_setObject:self.userName forKey:@"userName"];
    return dic;
}

- (instancetype)initFromDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.id = dic[@"id"];
        self.name = dic[@"name"];
        self.imgUrl = dic[@"imgUrl"];
        self.fee = dic[@"fee"];
        self.userName = dic[@"userName"];
    }
    return self;
}

+ (NSArray<NSDictionary *> *)dictionariesFromGifts:(NSArray<YPBGift *> *)gifts {
    NSMutableArray<NSDictionary *> *arr = [NSMutableArray array];
    [gifts enumerateObjectsUsingBlock:^(YPBGift * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:[obj dictionaryRepresentation]];
    }];
    return arr.count > 0 ? arr : nil;
}

+ (NSArray<YPBGift *> *)giftsFromArray:(NSArray<NSDictionary *> *)arr {
    NSMutableArray<YPBGift *> *gifts = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gifts addObject:[[YPBGift alloc] initFromDictionary:obj]];
    }];
    return gifts.count > 0 ? gifts : nil;
}

- (NSNumber *)fee {
#ifdef DEBUG
    return @1;
#else
    return _fee;
#endif
}
@end

@interface YPBUser ()
@property (nonatomic) NSString *name;

- (instancetype)initFromUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)userInfo;
@end

@implementation YPBUser

- (id)copyWithZone:(NSZone *)zone {
    YPBUser *copiedUser              = [[self class] allocWithZone:zone];
    copiedUser.name                  = [self.name copyWithZone:zone];
    copiedUser.userId                = [self.userId copyWithZone:zone];
    copiedUser.uuid                  = [self.uuid copyWithZone:zone];
    copiedUser.nickName              = [self.nickName copyWithZone:zone];
    copiedUser.password              = [self.password copyWithZone:zone];
    copiedUser.city                  = [self.city copyWithZone:zone];
    copiedUser.province              = [self.province copyWithZone:zone];
    copiedUser.openid                = [self.openid copyWithZone:zone];
    copiedUser.unionid               = [self.unionid copyWithZone:zone];
    copiedUser.logoUrl               = [self.logoUrl copyWithZone:zone];
    copiedUser.sex                   = [self.sex copyWithZone:zone];
    copiedUser.userType              = [self.userType copyWithZone:zone];
    
    copiedUser.age                   = [self.age copyWithZone:zone];
    copiedUser.height                = [self.height copyWithZone:zone];
    copiedUser.bwh                   = [self.bwh copyWithZone:zone];
    copiedUser.monthIncome           = [self.monthIncome copyWithZone:zone];
    copiedUser.note                  = [self.note copyWithZone:zone];
    copiedUser.profession            = [self.profession copyWithZone:zone];
    copiedUser.weixinNum             = [self.weixinNum copyWithZone:zone];
    copiedUser.assets                = [self.assets copyWithZone:zone];
    copiedUser.purpose               = [self.purpose copyWithZone:zone];
    
    copiedUser.isVip                 = self.isVip;
    copiedUser.vipEndTime            = [self.vipEndTime copyWithZone:zone];

    copiedUser.greetCount            = [self.greetCount copyWithZone:zone];
    copiedUser.accessCount           = [self.accessCount copyWithZone:zone];
    copiedUser.receiveGreetCount     = [self.receiveGreetCount copyWithZone:zone];
    copiedUser.userPhotos            = [[NSArray alloc] initWithArray:self.userPhotos copyItems:YES];

    copiedUser.readGreetCount        = [self.readGreetCount copyWithZone:zone];
    copiedUser.readAccessCount       = [self.readAccessCount copyWithZone:zone];
    copiedUser.readReceiveGreetCount = [self.readReceiveGreetCount copyWithZone:zone];

    copiedUser.gender                = self.gender;
    copiedUser.targetHeight          = self.targetHeight;
    copiedUser.targetAge             = self.targetAge;
    copiedUser.targetCup             = self.targetCup;
    
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

+ (NSArray<NSString *>*)allSelfEducationDescription {
    NSMutableArray *arr = [self allEducationsDescription].mutableCopy;
    arr[0] = kSecretDescription;
    return  arr;
}

+ (NSArray<NSString *>*)allEducationsDescription {
    return @[@"",@"小学",@"初中",@"高中",@"大专",@"本科",@"硕士及以上"];
}

+ (NSArray<NSString *> *)allSelfMarriageDescription {
    NSMutableArray *arr = [self allMarriageDescription].mutableCopy;
    arr[0] = kSecretDescription;
    return arr;
}

+ (NSArray<NSString *> *)allMarriageDescription {
    return @[@"",@"未婚",@"离异",@"丧偶"];
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

+ (NSArray<NSNumber *> *)allWaistValues {
    YPBFloatRange waistRange = self.availableWaistRange;
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (CGFloat i = waistRange.min; i < waistRange.max+0.5; i+=0.5) {
        [values addObject:@(i)];
    }
    return values;
}

+ (NSArray<NSNumber *> *)allHipValues {
    YPBFloatRange hipRange = self.availableHipRange;
    
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    for (CGFloat i = hipRange.min; i < hipRange.max+0.5; i+=0.5) {
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
    YPBFloatRange bustRange = {70,120};
    return bustRange;
}

+ (YPBFloatRange)availableWaistRange {
    YPBFloatRange waistRange = {55,100};
    return waistRange;
}

+ (YPBFloatRange)availableHipRange {
    YPBFloatRange hipRange = {70,120};
    return hipRange;
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

- (Class)userVideoClass {
    return [YPBUserVideo class];
}

- (Class)giftsElementClass {
    return [YPBGift class];
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
        _password          = userInfo[KUserPasswordKeyName];
        _province          = userInfo[kUserProvinceName];
        _city              = userInfo[kUserCityName];
        _openid            = userInfo[kUserOpenidKeyName];
        _unionid           = userInfo[kUserUnionidKeyName];
        _logoUrl           = userInfo[kUserLogoKeyName];
        _age               = userInfo[kUserAgeKeyName];
        _height            = userInfo[kUserHeightKeyName];
        _bwh               = userInfo[kUserFigureKeyName];
        _monthIncome       = userInfo[kUserIncomeKeyName];
        _note              = userInfo[kUserInterestKeyName];
        _profession        = userInfo[kUserProfessionKeyName];
        _weixinNum         = userInfo[kUserWeChatKeyName];
        _assets            = userInfo[kUserAssetsKeyName];
        _purpose           = userInfo[kUserPurposeKeyName];
        
        _isVip             = ((NSNumber *)userInfo[kUserIsVIPKeyName]).boolValue;
        _vipEndTime        = userInfo[kUserVIPEndTimeKeyName];

        _greetCount        = userInfo[kUserGreetCountKeyName];
        _receiveGreetCount = userInfo[kUserReceiveGreetCountKeyName];
        _accessCount       = userInfo[kUserAccessCountKeyName];
        
        _readGreetCount        = userInfo[kUserReadGreetCountKeyName];
        _readAccessCount       = userInfo[kUserReadAccessCountKeyName];
        _readReceiveGreetCount = userInfo[kUserReceiveGreetCountKeyName];
        
        _userPhotos        = [YPBUserPhoto userPhotosFromArray:userInfo[kUserPhotosKeyName]];
        _gifts             = [YPBGift giftsFromArray:userInfo[kUserGiftsKeyName]];
        
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
    [userInfo safely_setObject:self.password forKey:KUserPasswordKeyName];
    [userInfo safely_setObject:self.city forKey:kUserCityName];
    [userInfo safely_setObject:self.province forKey:kUserProvinceName];
    [userInfo safely_setObject:self.openid forKey:kUserOpenidKeyName];
    [userInfo safely_setObject:self.unionid forKey:kUserUnionidKeyName];
    [userInfo safely_setObject:self.logoUrl forKey:kUserLogoKeyName];
    [userInfo safely_setObject:self.age forKey:kUserAgeKeyName];
    [userInfo safely_setObject:self.height forKey:kUserHeightKeyName];
    [userInfo safely_setObject:self.bwh forKey:kUserFigureKeyName];
    [userInfo safely_setObject:self.monthIncome forKey:kUserIncomeKeyName];
    [userInfo safely_setObject:self.note forKey:kUserInterestKeyName];
    [userInfo safely_setObject:self.profession forKey:kUserProfessionKeyName];
    [userInfo safely_setObject:self.weixinNum forKey:kUserWeChatKeyName];
    [userInfo safely_setObject:self.assets forKey:kUserAssetsKeyName];
    [userInfo safely_setObject:self.purpose forKey:kUserPurposeKeyName];
    
    [userInfo setObject:@(self.isVip) forKey:kUserIsVIPKeyName];
    [userInfo safely_setObject:self.vipEndTime forKey:kUserVIPEndTimeKeyName];
    
    [userInfo safely_setObject:self.greetCount forKey:kUserGreetCountKeyName];
    [userInfo safely_setObject:self.receiveGreetCount forKey:kUserReceiveGreetCountKeyName];
    [userInfo safely_setObject:self.accessCount forKey:kUserAccessCountKeyName];
    
    [userInfo safely_setObject:self.readGreetCount forKey:kUserReadGreetCountKeyName];
    [userInfo safely_setObject:self.readReceiveGreetCount forKey:kUserReadReceiveGreetCountKeyName];
    [userInfo safely_setObject:self.readAccessCount forKey:kUserReadAccessCountKeyName];
    
    [userInfo safely_setObject:[YPBUserPhoto dictionariesFromUserPhotos:self.userPhotos] forKey:kUserPhotosKeyName];
    [userInfo safely_setObject:[YPBGift dictionariesFromGifts:self.gifts] forKey:kUserGiftsKeyName];
    //Target
    [userInfo safely_setInteger:self.targetCup forKey:kUserTargetCupKeyName];
    [userInfo safely_setObject:@[@(self.targetHeight.min),@(self.targetHeight.max)] forKey:kUserTargetHeightRangeKeyName];
    [userInfo safely_setObject:@[@(self.targetAge.min),@(self.targetAge.max)] forKey:kUserTargetAgeRangeKeyName];
    return userInfo;
}

- (BOOL)isRegistered {
    return self.userId.length > 0;
}

- (void)saveAsCurrentUser {
//    if (_currentUser == self) {
//        return;
//    }
    
    if (_currentUser != self) {
        
        NSNumber *readGreetCount;
        if (_currentUser.readGreetCount != nil || self.readGreetCount != nil) {
            readGreetCount = @(MAX(_currentUser.readGreetCount.unsignedIntegerValue, self.readGreetCount.unsignedIntegerValue));
        }
        
        NSNumber *readAccessCount;
        if (_currentUser.readAccessCount != nil || self.readAccessCount != nil) {
            readAccessCount = @(MAX(_currentUser.readAccessCount.unsignedIntegerValue, self.readAccessCount.unsignedIntegerValue));
        }
        
        NSNumber *readReceiveCount;
        if (_currentUser.readReceiveGreetCount != nil || self.readReceiveGreetCount != nil) {
            readReceiveCount = @(MAX(_currentUser.readReceiveGreetCount.unsignedIntegerValue, self.readReceiveGreetCount.unsignedIntegerValue));
        }
        
        _currentUser = self;
        _currentUser.readGreetCount = readGreetCount;
        _currentUser.readAccessCount = readAccessCount;
        _currentUser.readReceiveGreetCount = readReceiveCount;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.userInfo forKey:kUserInfoKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentUserChangeNotification object:_currentUser];
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

- (NSString *)cupDescription {
    if (self.cup < [[self class] allCupsDescription].count) {
        return [[self class] allCupsDescription][self.cup];
    }
    return @"";
}

- (NSString *)figureDescription {
    if (self.gender == YPBUserGenderUnknown) {
        return @"身材：？？？";
    } else if (self.gender == YPBUserGenderMale) {
        return [NSString stringWithFormat:@"体重：%@", [self weightDescription] ?: @""];
    } else {
        return [NSString stringWithFormat:@"身材：%@", self.bwh ?: @""];
    }
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

- (NSString *)bustDescription {
    if (self.bust == 0) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%.1f", self.bust];
}

- (NSString *)waistDescription {
    if (self.waist == 0) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%.1f", self.waist];
}

- (NSString *)hipDescription {
    if (self.hip == 0) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%.1f", self.hip];
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

- (NSString *)selfEducationDescription {
    return [[self class] allSelfEducationDescription][self.selfEducation];
}

- (NSString *)selfMarriageDescripiton {
    return [[self class] allSelfMarriageDescription][self.selfMarriage];
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

- (void)setBust:(CGFloat)bust {
    self.bwh = [NSString stringWithFormat:@"%.1f %.1f %.1f %@", bust, self.waist, self.hip, self.cupDescription];
}

- (CGFloat)waist {
    NSArray<NSString *> *bwh = [self.bwh componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (bwh.count > 1) {
        return bwh[1].floatValue;
    }
    return 0;
}

- (void)setWaist:(CGFloat)waist {
    self.bwh = [NSString stringWithFormat:@"%.1f %.1f %.1f %@", self.bust, waist, self.hip, self.cupDescription];
}

- (CGFloat)hip {
    NSArray<NSString *> *bwh = [self.bwh componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (bwh.count > 2) {
        return bwh[2].floatValue;
    }
    return 0;
}

- (void)setHip:(CGFloat)hip {
    self.bwh = [NSString stringWithFormat:@"%.1f %.1f %.1f %@", self.bust, self.waist, hip, self.cupDescription];
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

- (void)setCup:(YPBUserCup)cup {
    NSString *cupDescription;
    if (cup < [[self class] allCupsDescription].count) {
        cupDescription = [[self class] allCupsDescription][cup];
    }
    self.bwh = [NSString stringWithFormat:@"%.1f %.1f %.1f %@", self.bust, self.waist, self.hip, cupDescription ?: @""];
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

- (void)addOriginalPhotoUrls:(NSArray<NSString *> *)originalPhotoUrls
              thumbPhotoUrls:(NSArray<NSString *> *)thumbPhotoUrls {
    if (originalPhotoUrls.count != thumbPhotoUrls.count) {
        return ;
    }
    
    NSMutableArray<YPBUserPhoto *> *photos = self.userPhotos.mutableCopy;
    [originalPhotoUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *originalPhotoUrl = obj;
        NSString *thumbPhotoUrl = thumbPhotoUrls[idx];
        
        YPBUserPhoto *photo = [[YPBUserPhoto alloc] init];
        photo.smallPhoto = thumbPhotoUrl;
        photo.bigPhoto = originalPhotoUrl;
        photo.userId = self.userId;
        [photos insertObject:photo atIndex:0];
    }];
    self.userPhotos = photos;
}

- (NSArray<YPBUserPhoto *> *)userPhotos {
    return [_userPhotos sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        YPBUserPhoto *photo1 = obj1;
        YPBUserPhoto *photo2 = obj2;
        return -[photo1.id compare:photo2.id];
    }];
}

- (BOOL)deleteUserPhoto:(YPBUserPhoto *)photo {
    NSMutableArray *photoArr = _userPhotos.mutableCopy;
    YPBUserPhoto *deletePhoto = [_userPhotos bk_match:^BOOL(YPBUserPhoto *itrPhoto) {
        return itrPhoto.id && [itrPhoto.id isEqualToNumber:photo.id];
    }];
    
    if (deletePhoto) {
        [photoArr removeObject:deletePhoto];
        _userPhotos = photoArr;
    }
    return deletePhoto != nil;
}

- (NSUInteger)unreadGreetCount {
    return MAX(0, self.greetCount.integerValue - self.readGreetCount.integerValue);
}

- (NSUInteger)unreadAccessCount {
    return MAX(0, self.accessCount.integerValue - self.readAccessCount.integerValue);
}

- (NSUInteger)unreadReceiveGreetCount {
    return MAX(0, self.receiveGreetCount.integerValue - self.readReceiveGreetCount.integerValue);
}

- (NSUInteger)unreadTotalCount {
    return self.unreadAccessCount + self.unreadGreetCount + self.unreadReceiveGreetCount;
}

- (NSString *)purpose {
    if (_purpose.length > 0) {
        return _purpose;
    }
    return @"无所谓";
}
@end
