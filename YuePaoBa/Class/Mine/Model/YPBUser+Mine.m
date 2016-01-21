//
//  YPBUser+Mine.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUser+Mine.h"

static const NSUInteger kDefaultAge = 25;
static const NSUInteger kDefaultHeight = 160;

@implementation YPBUser (Mine)

+ (NSArray<NSString *> *)allAgeStrings {
    NSMutableArray *arr = [NSMutableArray array];
    YPBIntRange ageRange = [self availableAgeRange];
    for (NSUInteger i = ageRange.min; i <= ageRange.max; ++i) {
        [arr addObject:[NSString stringWithFormat:@"%ld岁", i]];
    }
    return arr;
}

+ (NSArray<NSString *> *)allHeightStrings {
    NSMutableArray *arr = [NSMutableArray array];
    YPBIntRange heightRange = [self availableHeightRange];
    for (NSUInteger i = heightRange.min; i <= heightRange.max; ++i) {
        [arr addObject:[NSString stringWithFormat:@"%ld cm",i]];
    }
    return arr;
}

+ (NSArray<NSString *> *)allAssetsStrings {
    return @[@"无车无房",@"有车无房",@"有房无车",@"有房有车"];
}

+ (NSArray<NSString *> *)allWeightStrings {
    NSMutableArray *weightStrings = [NSMutableArray array];
    [[self allWeightRangeValues] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weightStrings addObject:[NSString stringWithFormat:@"%.1f kg", obj.floatValue]];
    }];
    return weightStrings;
}

+ (NSArray<NSString *> *)allBustStrings {
    NSMutableArray *bustStrings = [NSMutableArray array];
    [[self allBustValues] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToNumber:@0]) {
            [bustStrings addObject:@""];
        } else {
            [bustStrings addObject:[NSString stringWithFormat:@"%.1f", obj.floatValue]];
        }
    }];
    return bustStrings.count > 0 ? bustStrings : nil;
}

+ (NSArray<NSString *> *)allWaistStrings {
    NSMutableArray *waistStrings = [NSMutableArray array];
    [[self allWaistValues] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToNumber:@0]) {
            [waistStrings addObject:@""];
        } else {
            [waistStrings addObject:[NSString stringWithFormat:@"%.1f", obj.floatValue]];
        }
    }];
    return waistStrings.count > 0 ? waistStrings : nil;
}

+ (NSArray<NSString *> *)allHipStrings {
    NSMutableArray *hipStrings = [NSMutableArray array];
    [[self allHipValues] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToNumber:@0]) {
            [hipStrings addObject:@""];
        } else {
            [hipStrings addObject:[NSString stringWithFormat:@"%.1f", obj.floatValue]];
        }
    }];
    return hipStrings.count > 0 ? hipStrings : nil;
}

- (NSUInteger)assetsIndex {
    NSArray *assetsStrings = [[self class] allAssetsStrings];
    NSUInteger index = [assetsStrings indexOfObject:self.assets];
    if (index == NSNotFound) {
        return [assetsStrings indexOfObject:@"有房有车"];
    }
    return index;
}

- (NSUInteger)ageIndex {
    YPBIntRange ageRange = [[self class] availableAgeRange];
    NSInteger ageIndex = self.age.integerValue-ageRange.min;
    if (ageIndex < 0) {
        return kDefaultAge-ageRange.min;
    } else {
        return ageIndex;
    }
}

- (NSUInteger)heightIndex {
    YPBIntRange heightRange = [[self class] availableHeightRange];
    NSInteger heightIndex = self.height.integerValue-heightRange.min;
    if (heightIndex < 0) {
        return kDefaultHeight-heightRange.min;
    } else {
        return heightIndex;
    }
}

- (NSUInteger)weightIndex {
    YPBFloatRange weightRange = [[self class] availableWeightRange];
    CGFloat weight = self.weight < weightRange.min ? 60 : self.weight;
    return lroundf((weight-weightRange.min)/0.5);
}

- (void)setAgeWithIndex:(NSUInteger)ageIndex {
    YPBIntRange ageRange = [[self class] availableAgeRange];
    self.age = @(ageRange.min+ageIndex);
}

- (void)setHeightWithIndex:(NSUInteger)heightIndex {
    YPBIntRange heightRange = [[self class] availableHeightRange];
    self.height = @(heightRange.min+heightIndex);
}

- (void)setWeightWithIndex:(NSUInteger)weightIndex {
    YPBFloatRange weightRange = [[self class] availableWeightRange];
    self.weight = weightRange.min+weightIndex*0.5;
}

+ (NSArray<NSString *> *)allIncomeStrings {
    return @[@"3k以下",@"3k~5k",@"5k~10k",@"10k~20k",@"20k以上"];
}

+ (NSArray<NSString *> *)incomeMappedRestValues {
    return @[@"0~3000",@"3000~5000",@"5000~10000",@"10000~200000",@"200000~"];
}

- (NSUInteger)incomeIndex {
    NSArray *mappedRestValues = [[self class] incomeMappedRestValues];
    NSUInteger index = [mappedRestValues indexOfObject:self.monthIncome];
    if (index == NSNotFound) {
        return mappedRestValues.count / 2;
    }
    return index;
}

- (void)setIncomeWithIndex:(NSUInteger)incomeIndex {
    NSArray *mappedRestValues = [[self class] incomeMappedRestValues];
    if (incomeIndex >= mappedRestValues.count) {
        return ;
    }
    
    self.monthIncome = mappedRestValues[incomeIndex];
}

- (void)setAssetsWithIndex:(NSUInteger)assetsIndex {
    NSArray *mappedAssets = [[self class] allAssetsStrings];
    if (assetsIndex >= mappedAssets.count) {
        return ;
    }
    
    self.assets = mappedAssets[assetsIndex];
}
@end
