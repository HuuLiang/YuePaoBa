//
//  YPBUser.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YPBUserGender) {
    YPBUserGenderUnknown,
    YPBUserGenderMale,
    YPBUserGenderFemale
};

typedef NS_ENUM(NSUInteger, YPBUserCup) {
    YPBUserCupUnspecified,
    YPBUserCupA,
    YPBUserCupB,
    YPBUserCupC,
    YPBUserCupCPlus
};

@interface YPBUserPhoto : NSObject <NSCopying>
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *smallPhoto;
@property (nonatomic) NSString *bigPhoto;
@property (nonatomic) NSNumber *sort;
@end

@interface YPBUser : NSObject <NSCopying>

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *uuid; //激活码
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *sex;

@property (nonatomic) NSNumber *age;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSString *bwh; // 身材
@property (nonatomic) NSString *monthIncome;
@property (nonatomic) NSString *note; // 兴趣
@property (nonatomic) NSString *profession;
@property (nonatomic) NSString *weixinNum;
@property (nonatomic) NSString *assets;

@property (nonatomic) BOOL isGreet;
@property (nonatomic) BOOL isVip;
@property (nonatomic) NSString *vipEndTime;

@property (nonatomic) NSNumber *greetCount;
@property (nonatomic) NSNumber *accessCount;
@property (nonatomic) NSNumber *receiveGreetCount;
@property (nonatomic) NSArray<YPBUserPhoto *> *userPhotos;

@property (nonatomic) YPBUserGender gender;
@property (nonatomic) YPBIntRange targetHeight;
@property (nonatomic) YPBIntRange targetAge;
@property (nonatomic) YPBUserCup targetCup;
@property (nonatomic) CGFloat weight;

@property (nonatomic,readonly) YPBUserGender oppositeGender;

+ (instancetype)currentUser;
//- (instancetype)init __attribute__((unavailable("cannot use init for this class, use +(instancetype)currentUser instead")));
+ (NSArray<NSString *> *)allTargetCupsDescription;
+ (NSArray<NSString *> *)allCupsDescription;
+ (NSArray<NSString *> *)allHeightRangeDescription;
+ (NSArray<NSString *> *)allAgeRangeDescription;
+ (NSArray<NSNumber *> *)allHeightRangeValues;
+ (NSArray<NSNumber *> *)allWeightRangeValues;
+ (NSArray<NSNumber *> *)allAgeValues;
+ (NSArray<NSNumber *> *)allBustValues;

+ (YPBUserGender)genderFromString:(NSString *)genderString;
+ (NSString *)stringOfGender:(YPBUserGender)gender;
+ (YPBIntRange)availableHeightRange;
+ (YPBIntRange)availableAgeRange;
+ (YPBFloatRange)availableWeightRange;
+ (YPBFloatRange)availableBustRange;

- (BOOL)isRegistered;
- (void)saveAsCurrentUser;
- (NSError *)validate;
- (void)addOriginalPhotoUrls:(NSArray<NSString *> *)originalPhotoUrls
              thumbPhotoUrls:(NSArray<NSString *> *)thumbPhotoUrls;

- (CGFloat)bust;  // 胸围
- (CGFloat)waist; // 腰围
- (CGFloat)hip;   // 臀围
- (YPBUserCup)cup;

- (NSString *)heightDescription;
- (NSString *)ageDescription;
- (NSString *)weightDescription;

- (NSString *)targetHeightDescription;
- (NSString *)targetAgeDescription;
- (NSString *)targetCupDescription;

@end

extern NSString *const kNotLimitedDescription;
