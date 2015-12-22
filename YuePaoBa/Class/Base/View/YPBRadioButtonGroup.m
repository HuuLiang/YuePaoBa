//
//  YPBRadioButtonGroup.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBRadioButtonGroup.h"
#import "YPBRadioButton.h"

@interface YPBRadioButtonGroup ()
@property (nonatomic,retain,readonly) NSArray<YPBRadioButton *> *radioButtons;
@end

@implementation YPBRadioButtonGroup

+ (instancetype)groupWithRadioButtons:(NSArray<YPBRadioButton *> *)radioButtons {
    return [[self alloc] initWithRadioButtons:radioButtons];
}

- (instancetype)initWithRadioButtons:(NSArray<YPBRadioButton *> *)radioButtons {
    self = [super init];
    if (self) {
        _radioButtons = radioButtons;
        
        [radioButtons enumerateObjectsUsingBlock:^(YPBRadioButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj addTarget:self action:@selector(onRadioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        
        if (!self.selectedButton && radioButtons.count > 0) {
            radioButtons[0].selected = YES;
        }
    }
    return self;
}

- (YPBRadioButton *)selectedButton {
    return [self.radioButtons bk_match:^BOOL(YPBRadioButton *obj) {
        return obj.selected;
    }];
}

- (void)onRadioButtonSelected:(id)sender {
    YPBRadioButton *buttonToSelect = sender;
    if (![self.radioButtons containsObject:buttonToSelect]) {
        return ;
    }
    
    self.selectedButton.selected = NO;
    buttonToSelect.selected = YES;
}
@end
