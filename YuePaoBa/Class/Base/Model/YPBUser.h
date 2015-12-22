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

typedef NS_ENUM(NSUInteger, YPBTargetCup) {
    YPBTargetCupUnlimited,
    YPBTargetCupA,
    YPBTargetCupB,
    YPBTargetCupC,
    YPBTargetCupCPlus
};

@interface YPBUserPhoto : NSObject
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *smallPhoto;
@property (nonatomic) NSString *bigPhoto;
@property (nonatomic) NSNumber *sort;
@end

@interface YPBUser : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *uuid; //激活码
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *note;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *sex;

@property (nonatomic) NSNumber *age;
@property (nonatomic) NSNumber *height;

@property (nonatomic) BOOL isMember;
@property (nonatomic) BOOL isVip;

@property (nonatomic) NSString *memberEndTime;
@property (nonatomic) NSString *vipEndTime;

@property (nonatomic) NSNumber *greetCount;
@property (nonatomic) NSNumber *accessCount;
@property (nonatomic) NSArray<YPBUserPhoto *> *userPhotos;

@property (nonatomic) YPBUserGender gender;
@property (nonatomic) YPBIntRange targetHeight;
@property (nonatomic) YPBIntRange targetAge;
@property (nonatomic) YPBTargetCup targetCup;

+ (instancetype)currentUser;
//- (instancetype)init __attribute__((unavailable("cannot use init for this class, use +(instancetype)currentUser instead")));
+ (NSArray<NSString *> *)allCupsDescription;
+ (NSArray<NSString *> *)allHeightRangeDescription;
+ (NSArray<NSString *> *)allAgeRangeDescription;
+ (NSArray<NSNumber *> *)allHeightValues;
+ (NSArray<NSNumber *> *)allAgeValues;
+ (YPBUserGender)genderFromString:(NSString *)genderString;
+ (NSString *)stringOfGender:(YPBUserGender)gender;

- (BOOL)isRegistered;
- (void)setAsCurrentUser;
- (NSError *)validate;

- (NSString *)targetHeightDescription;
- (NSString *)targetAgeDescription;
- (NSString *)targetCupDescription;

@end

extern NSString *const kNotLimitedDescription;
