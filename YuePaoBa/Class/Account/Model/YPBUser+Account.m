//
//  YPBUser+Helper.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUser+Account.h"

@implementation YPBUser (Account)

- (void)setTargetHeightWithRangeStringBetween:(NSString *)value1 and:(NSString *)value2 {
    YPBIntRange heightRange;
    if ([value1 isEqualToString:kNotLimitedDescription]) {
        heightRange.min = 0;
    } else {
        heightRange.min = value1.integerValue;
    }
    
    if ([value2 isEqualToString:kNotLimitedDescription]) {
        heightRange.max = 0;
    } else {
        heightRange.max = value2.integerValue;
    }
    
    if (![value1 isEqualToString:kNotLimitedDescription]
        && ![value2 isEqualToString:kNotLimitedDescription]) {
        if (heightRange.min > heightRange.max) {
            SWAP(heightRange.min, heightRange.max);
        }
    }
    
    self.targetHeight = heightRange;
}

- (void)setTargetAgeWithRangeStringBetween:(NSString *)value1 and:(NSString *)value2 {
    YPBIntRange ageRange;
    if ([value1 isEqualToString:kNotLimitedDescription]) {
        ageRange.min = 18;
    } else {
        ageRange.min = value1.integerValue;
    }
    
    if ([value2 isEqualToString:kNotLimitedDescription]) {
        ageRange.max = 0;
    } else {
        ageRange.max = value2.integerValue;
    }
    
    if (![value1 isEqualToString:kNotLimitedDescription]
        && ![value2 isEqualToString:kNotLimitedDescription]) {
        if (ageRange.min > ageRange.max) {
            SWAP(ageRange.min, ageRange.max);
        }
    }
    self.targetAge = ageRange;
}

- (void)setTargetCupWithString:(NSString *)cupString {
    NSUInteger index = [[[self class] allCupsDescription] indexOfObject:cupString];
    if (index != NSNotFound) {
        self.targetCup = index;
    }
}

- (void)setSelfAgeWithAge:(NSString *)value {
//    NSUInteger index = [[[self class] allSelfAgeDescription] indexOfObject:value];
//    if (index != NSNotFound) {
//        self.age = [NSNumber numberWithUnsignedInteger:index];
//    }
    self.age = [NSNumber numberWithInteger:[value integerValue]];
}

- (YPBPair *)valueIndexesOfTargetHeight {
    NSUInteger minIndex = [[[self class] allHeightRangeValues] indexOfObject:@(self.targetHeight.min)];
    if (minIndex == NSNotFound) {
        minIndex = 0;
    }
    
    NSUInteger maxIndex = [[[self class] allHeightRangeValues] indexOfObject:@(self.targetHeight.max)];
    if (maxIndex == NSNotFound) {
        maxIndex = 0;
    }
    return @[@(minIndex), @(maxIndex)];
}

- (YPBPair *)valueIndexesOfTargetAge {
    NSUInteger minIndex = [[[self class] allAgeValues] indexOfObject:@(self.targetAge.min)];
    if (minIndex == NSNotFound) {
        minIndex = 0;
    }
    
    NSUInteger maxIndex = [[[self class] allAgeValues] indexOfObject:@(self.targetAge.max)];
    if (maxIndex == NSNotFound) {
        maxIndex = 0;
    }
    return @[@(minIndex), @(maxIndex)];
}

- (NSUInteger)valueIndexOfTargetCup {
    return self.targetCup;
}

- (NSUInteger)valueIndexOfSelfAge {
    if (self.age == nil || self.age == 0) {
        return 0;
    } else {
        return [self.age unsignedIntegerValue] - 17;
    }
//    return [self.age unsignedIntegerValue];
}

@end
