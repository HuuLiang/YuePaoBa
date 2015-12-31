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
- (void)setTargetCupWithString:(NSString *)cupString;

- (YPBPair *)valueIndexesOfTargetHeight;
- (YPBPair *)valueIndexesOfTargetAge;
- (NSUInteger)valueIndexOfTargetCup;

@end
