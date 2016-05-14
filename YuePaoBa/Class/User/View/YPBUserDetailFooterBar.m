//
//  YPBUserDetailFooterBar.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserDetailFooterBar.h"

@interface YPBUserDetailFooterBarItem : UIButton

@end

@implementation YPBUserDetailFooterBarItem

- (instancetype)init {
    self = [super init];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:11.];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.8]] forState:UIControlStateHighlighted];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (CGRectIsEmpty(contentRect)) {
        return CGRectZero;
    }
    const CGFloat imageWidth = CGRectGetHeight(contentRect) / 2 - 5;
    const CGFloat imageHeight = imageWidth;
    const CGFloat imageX = (CGRectGetWidth(contentRect)-imageWidth)/2;
    return CGRectMake(imageX, 8, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (CGRectIsEmpty(contentRect)) {
        return CGRectZero;
    }
    
    const CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat titleWidth = CGRectGetWidth(contentRect);
    const CGFloat titleHeight = CGRectGetHeight(contentRect)-10-CGRectGetMaxY(imageRect);
    return CGRectMake(0, CGRectGetMaxY(imageRect)+5, titleWidth, titleHeight);
}
@end

@interface YPBUserDetailFooterBar ()
{
    YPBUserDetailFooterBarItem *_greetItem;
    YPBUserDetailFooterBarItem *_giftItem;
    YPBUserDetailFooterBarItem *_dateItem;
}
@end

@implementation YPBUserDetailFooterBar

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        
        @weakify(self);
        
        _dateItem = [[YPBUserDetailFooterBarItem alloc] init];
        _dateItem.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [_dateItem setTitle:@"聊天" forState:UIControlStateNormal];
        [_dateItem setTitleColor:[UIColor colorWithHexString:@"#fbceaf"] forState:UIControlStateNormal];
        [_dateItem setImage:[UIImage imageNamed:@"user_date_footer_icon"] forState:UIControlStateNormal];
        [_dateItem bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.dateAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dateItem];
        {
            [_dateItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.equalTo(@(SCREEN_WIDTH*0.22));
            }];
        }
        
        _giftItem = [[YPBUserDetailFooterBarItem alloc] init];
        _giftItem.backgroundColor = [UIColor colorWithHexString:@"#fb9d9b"];
        [_giftItem setTitle:@"送礼物" forState:UIControlStateNormal];
        [_giftItem setImage:[UIImage imageNamed:@"user_gift_footer_icon"] forState:UIControlStateNormal];
        [_giftItem bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.giftAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_giftItem];
        {
            [_giftItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(_dateItem.mas_right);
                make.width.equalTo(@(SCREEN_WIDTH*0.35));
            }];
        }
    
        _greetItem = [[YPBUserDetailFooterBarItem alloc] init];
        _greetItem.backgroundColor = [UIColor colorWithHexString:@"#fe4565"];
        [_greetItem setTitle:@"打招呼" forState:UIControlStateNormal];
//        [_greetItem setTitleColor:[UIColor colorWithHexString:@"#fbceaf"] forState:UIControlStateNormal];
        [_greetItem setImage:[UIImage imageNamed:@"user_greet_footer_icon"] forState:UIControlStateNormal];
        [_greetItem setImage:[UIImage imageNamed:@"user_greeted_footer_icon"] forState:UIControlStateSelected];
        [_greetItem bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.greetAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_greetItem];
        {
            [_greetItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self);
                make.left.equalTo(_giftItem.mas_right);
            }];
        }
    }
    return self;
}

- (void)setIsGreet:(BOOL)isGreet {
    _isGreet = isGreet;
    _greetItem.selected = isGreet;
}

- (void)setNumberOfGreets:(NSUInteger)numberOfGreets {
    _numberOfGreets = numberOfGreets;
    
    NSString *title = @"打招呼";
    if (numberOfGreets > 0 && numberOfGreets < 1000) {
        title = [title stringByAppendingFormat:@"(%ld)", (unsigned long)numberOfGreets];
    } else {
        title = [title stringByAppendingString:@"(999+)"];
    }
    [_greetItem setTitle:title forState:UIControlStateNormal];
}
@end
