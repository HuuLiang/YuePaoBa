//
//  YPBRadioButtonGroup.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPBRadioButton;

@interface YPBRadioButtonGroup : NSObject

@property (nonatomic,retain,readonly) YPBRadioButton *selectedButton;

+ (instancetype)groupWithRadioButtons:(NSArray<YPBRadioButton *> *)radioButtons;
- (instancetype)initWithRadioButtons:(NSArray<YPBRadioButton *> *)radioButtons;

@end
