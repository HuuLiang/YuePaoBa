//
//  YPBVideoGiftPollingCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVideoGiftPollingCell.h"

@interface YPBVideoGiftPollingCell ()
{
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
}
@end

@implementation YPBVideoGiftPollingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.8);
                make.width.equalTo(_iconImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        [_titleLabel aspect_hookSelector:@selector(textRectForBounds:limitedToNumberOfLines:)
                             withOptions:AspectPositionInstead
                              usingBlock:^(id<AspectInfo> aspectInfo,
                                           CGRect bounds,
                                           NSInteger numberOfLines)
         {
             CGRect textRect;
             [[aspectInfo originalInvocation] invoke];
             [[aspectInfo originalInvocation] getReturnValue:&textRect];
             
             textRect = CGRectMake(textRect.origin.x+5, textRect.origin.y, textRect.size.width+10, textRect.size.height);
             [[aspectInfo originalInvocation] setReturnValue:&textRect];
         } error:nil];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconImageView.mas_right).offset(10);
                make.right.lessThanOrEqualTo(self).offset(-15);
                make.centerY.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)setGiftImageUrl:(NSURL *)imageUrl name:(NSString *)giftName sender:(NSString *)sender {
    [_iconImageView sd_setImageWithURL:imageUrl];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收到%@送的%@", sender ?: @"", giftName]];
    //[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收到%@送的%@", item.sender, giftName] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14.]}];
    if (sender.length > 0) {
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, sender.length)];
    }
    _titleLabel.attributedText = title;
}

@end
