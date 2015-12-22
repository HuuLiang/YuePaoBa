//
//  YPBActionButton.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBActionButton.h"

@implementation YPBActionButton

- (instancetype)initWithTitle:(NSString *)title action:(YPBButtonAction)action {
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:22.];
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"button_background"] forState:UIControlStateNormal];
        [self bk_addEventHandler:^(id sender) {
            if (action) {
                action(sender);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
