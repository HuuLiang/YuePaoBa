//
//  YPBUser+Mine.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUser.h"

@interface YPBUser (Mine)

+ (NSArray<NSString *> *)allAgeStrings;
+ (NSArray<NSString *> *)allHeightStrings;
+ (NSArray<NSString *> *)allIncomeStrings;
+ (NSArray<NSString *> *)allAssetsStrings;
+ (NSArray<NSString *> *)allWeightStrings;
+ (NSArray<NSString *> *)allBustStrings;
+ (NSArray<NSString *> *)allWaistStrings;
+ (NSArray<NSString *> *)allHipStrings;

- (NSUInteger)ageIndex;
- (NSUInteger)heightIndex;
- (NSUInteger)incomeIndex;
- (NSUInteger)assetsIndex;
- (NSUInteger)weightIndex;

- (void)setAgeWithIndex:(NSUInteger)ageIndex;
- (void)setHeightWithIndex:(NSUInteger)heightIndex;
- (void)setIncomeWithIndex:(NSUInteger)incomeIndex;
- (void)setAssetsWithIndex:(NSUInteger)assetsIndex;
- (void)setWeightWithIndex:(NSUInteger)weightIndex;

@end
