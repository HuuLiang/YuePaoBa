//
//  YPBUser+Helper.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUser.h"

@interface YPBUser (Account)

- (void)setTargetHeightWithRangeStringBetween:(NSString *)value1 and:(NSString *)value2;
- (void)setTargetAgeWithRangeStringBetween:(NSString *)value1 and:(NSString *)value2;
- (void)setSelfAgeWithAge:(NSString *)value;
- (void)setTargetCupWithString:(NSString *)cupString;
- (void)setSelfEducationWithString:(NSString *)educationString;
- (void)setSelfMarriageWithString:(NSString *)marriageString;

- (YPBPair *)valueIndexesOfTargetHeight;
- (YPBPair *)valueIndexesOfTargetAge;
- (NSUInteger)valueIndexOfTargetCup;
- (NSUInteger)valueIndexOfSelfEducation;
- (NSUInteger)valueIndexOfSelfMarriage;
- (NSUInteger)valueIndexOfSelfAge;
@end
