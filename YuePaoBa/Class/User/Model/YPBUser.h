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

typedef NS_ENUM(NSUInteger,YPBUserEducation) {
    YPBUserEducationNONE,
    YPBUserEducationA,
    YPBUserEducationB,
    YPBUserEducationC,
    YPBUserEducationD,
    YPBUserEducationE,
    YPBUserEducationF
};

typedef NS_ENUM(NSUInteger,YPBUserMarriage) {
    YPBUserMarriageUNKNOW,
    YPBUserMarriageA,
    YPBUserMarriageB,
    YPBUserMarriageC
};

typedef NS_ENUM(NSUInteger, YPBUserType) {
    YPBUserTypeUnknown,
    YPBUserTypeRobot,
    YPBUserTypeReal
};

@interface YPBUserPhoto : NSObject <NSCopying>
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *smallPhoto;
@property (nonatomic) NSString *bigPhoto;
@property (nonatomic) NSNumber *sort;
@end

@interface YPBUserVideo : NSObject <NSCopying>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *imgCover;
@property (nonatomic) NSString *videoUrl;

@end

@interface YPBGift : NSObject <NSCopying>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSNumber *fee;
@property (nonatomic) NSString *userName;

@end

@interface YPBUser : NSObject <NSCopying>

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *uuid; //激活码
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSNumber *userType;

@property (nonatomic) NSNumber *age;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSString *bwh; // 身材
@property (nonatomic) NSString *monthIncome;
@property (nonatomic) NSString *edu;
@property (nonatomic) NSString *marry;
@property (nonatomic) NSString *province;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *note; // 兴趣
@property (nonatomic) NSString *profession;
@property (nonatomic) NSString *weixinNum;
@property (nonatomic) NSString *assets;
@property (nonatomic) NSString *purpose;

@property (nonatomic) BOOL isGreet;
@property (nonatomic) BOOL isVip;
@property (nonatomic) NSString *vipEndTime;

@property (nonatomic) NSNumber *greetCount;
@property (nonatomic) NSNumber *accessCount;
@property (nonatomic) NSNumber *receiveGreetCount;
@property (nonatomic) NSArray<YPBUserPhoto *> *userPhotos;

@property (nonatomic) NSNumber *readGreetCount;
@property (nonatomic) NSNumber *readAccessCount;
@property (nonatomic) NSNumber *readReceiveGreetCount;

// Helper properties for access/greet
@property (nonatomic,readonly) NSUInteger unreadGreetCount;
@property (nonatomic,readonly) NSUInteger unreadAccessCount;
@property (nonatomic,readonly) NSUInteger unreadReceiveGreetCount;
@property (nonatomic,readonly) NSUInteger unreadTotalCount;

@property (nonatomic) YPBUserGender gender;
@property (nonatomic) YPBIntRange targetHeight;
@property (nonatomic) YPBIntRange targetAge;
@property (nonatomic) YPBUserCup targetCup;
@property (nonatomic) YPBUserEducation selfEducation;
@property (nonatomic) YPBUserMarriage selfMarriage;
@property (nonatomic) CGFloat weight;
@property (nonatomic) CGFloat bust;  //胸围
@property (nonatomic) CGFloat waist; //腰围
@property (nonatomic) CGFloat hip;   //臀围
@property (nonatomic) YPBUserCup cup;

@property (nonatomic,readonly) YPBUserGender oppositeGender;

@property (nonatomic) YPBUserVideo *userVideo;
@property (nonatomic,retain) NSArray<YPBGift *> *gifts;

+ (instancetype)currentUser;
//- (instancetype)init __attribute__((unavailable("cannot use init for this class, use +(instancetype)currentUser instead")));
+ (NSArray<NSString *> *)allTargetCupsDescription;
+ (NSArray<NSString *> *)allCupsDescription;
+ (NSArray<NSString *> *)allSelfEducationDescription;
+ (NSArray<NSString *> *)allEducationsDescription;
+ (NSArray<NSString *> *)allSelfMarriageDescription;
+ (NSArray<NSString *> *)allMarriageDescription;
+ (NSArray<NSString *> *)allHeightRangeDescription;
+ (NSArray<NSString *> *)allAgeRangeDescription;
+ (NSArray<NSString *> *)allSelfAgeDescription;
+ (NSArray<NSNumber *> *)allHeightRangeValues;
+ (NSArray<NSNumber *> *)allWeightRangeValues;
+ (NSArray<NSNumber *> *)allAgeValues;
+ (NSArray<NSNumber *> *)allBustValues;
+ (NSArray<NSNumber *> *)allWaistValues;
+ (NSArray<NSNumber *> *)allHipValues;

+ (YPBUserGender)genderFromString:(NSString *)genderString;
+ (NSString *)stringOfGender:(YPBUserGender)gender;
+ (YPBIntRange)availableHeightRange;
+ (YPBIntRange)availableAgeRange;
+ (YPBFloatRange)availableWeightRange;
+ (YPBFloatRange)availableBustRange;
+ (YPBFloatRange)availableWaistRange;
+ (YPBFloatRange)availableHipRange;

- (BOOL)isRegistered;
- (void)saveAsCurrentUser;
- (NSError *)validate;
- (void)addOriginalPhotoUrls:(NSArray<NSString *> *)originalPhotoUrls
              thumbPhotoUrls:(NSArray<NSString *> *)thumbPhotoUrls;

- (NSString *)heightDescription;
- (NSString *)ageDescription;
- (NSString *)weightDescription;
- (NSString *)figureDescription;
- (NSString *)bustDescription;
- (NSString *)waistDescription;
- (NSString *)hipDescription;
- (NSString *)cupDescription;

- (NSString *)targetHeightDescription;
- (NSString *)targetAgeDescription;
- (NSString *)targetCupDescription;

- (NSString *)selfEducationDescription;
- (NSString *)selfRevenusDescription;
- (NSString *)selfMarriageDescripiton;
- (NSString *)selfAgeDescription;
- (NSString *)selfHeightDescription;

- (BOOL)deleteUserPhoto:(YPBUserPhoto *)photo;

@end

extern NSString *const kNotLimitedDescription;
