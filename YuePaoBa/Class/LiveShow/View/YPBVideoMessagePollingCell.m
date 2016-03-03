//
//  YPBVideoMessagePollingCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVideoMessagePollingCell.h"

@interface YPBVideoMessagePollingCell ()

@end

@implementation YPBVideoMessagePollingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        _titleLabel.layer.cornerRadius = _titleLabel.font.pointSize/2;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel aspect_hookSelector:@selector(textRectForBounds:limitedToNumberOfLines:)
                             withOptions:AspectPositionInstead
                              usingBlock:^(id<AspectInfo> aspectInfo,
                                           CGRect bounds,
                                           NSInteger numberOfLines)
        {
            CGRect textRect;
            [[aspectInfo originalInvocation] invoke];
            [[aspectInfo originalInvocation] getReturnValue:&textRect];
            
            textRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width+10, textRect.size.height);
            [[aspectInfo originalInvocation] setReturnValue:&textRect];
        } error:nil];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(15);
                make.right.lessThanOrEqualTo(self).offset(-15);
            }];
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end
