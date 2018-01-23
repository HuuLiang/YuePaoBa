//
//  YPBContactCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBContactCell.h"

@interface YPBContactCell ()
{
    UIImageView *_thumbImageView;
    UIView *_thumbContainer;
    
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UIView *_messageContainer;
    
    UILabel *_notiLabel;
    UIView *_notiContainer;
}
@end

@implementation YPBContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        @weakify(self);
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.clipsToBounds = YES;
        [_thumbImageView bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock1(self.avatarTapAction, nil);
        }];
        [self.contentView addSubview:_thumbImageView];

        _notiLabel = [[UILabel alloc] init];
        _notiLabel.clipsToBounds = YES;
        _notiLabel.backgroundColor = [UIColor redColor];
        _notiLabel.textColor = [UIColor whiteColor];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.hidden = YES;
        [_notiLabel bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock1(self.notificationTapAction, nil);
        }];
        [self.contentView addSubview:_notiLabel];
        
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];

        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = kDefaultTextColor;
        [self.contentView addSubview:_subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    const CGFloat thumbHeight = lround(contentHeight * 0.75);
    const CGFloat thumbWidth = thumbHeight;
    const CGFloat thumbX = 15;
    const CGFloat thumbY = (contentHeight - thumbHeight) / 2;
    _thumbImageView.frame = CGRectMake(thumbX, thumbY, thumbWidth, thumbHeight);
    _thumbImageView.layer.cornerRadius = thumbHeight / 2;
    
    const CGFloat notiHeight = lround(thumbHeight*0.3);
    _notiLabel.font = [UIFont boldSystemFontOfSize:notiHeight * 0.6];
    CGSize notiSize = [_notiLabel.text sizeWithAttributes:@{NSFontAttributeName:_notiLabel.font}];
    const CGFloat notiWidth = MAX(notiHeight, notiSize.width+4);
    const CGFloat notiX = CGRectGetMaxX(_thumbImageView.frame) - notiWidth;
    const CGFloat notiY = thumbY;
    _notiLabel.frame = CGRectMake(notiX, notiY, notiWidth, notiHeight);
    _notiLabel.layer.cornerRadius = MIN(notiWidth, notiHeight)/2;
    
    
    const CGFloat titleX = CGRectGetMaxX(_thumbImageView.frame)+15;
    const CGFloat titleWidth = contentWidth - titleX - 15;
    const CGFloat titleHeight = lround(contentHeight * 0.22);
    const CGFloat titleY = contentHeight / 2 - titleHeight - 5;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    _titleLabel.font = [UIFont boldSystemFontOfSize:titleHeight];
    
    const CGFloat subtitleX = titleX;
    const CGFloat subtitleY = CGRectGetMaxY(_titleLabel.frame)+10;
    const CGFloat subtitleWidth = titleWidth;
    const CGFloat subtitleHeight = lround(titleHeight * 0.9);
    _subtitleLabel.frame = CGRectMake(subtitleX, subtitleY, subtitleWidth, subtitleHeight);
    _subtitleLabel.font = [UIFont systemFontOfSize:subtitleHeight];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
}

- (void)setNumberOfNotifications:(NSUInteger)numberOfNotifications {
    _numberOfNotifications = numberOfNotifications;
    if (numberOfNotifications > 99) {
        _notiLabel.text = @"99+";
    } else {
        _notiLabel.text = @(numberOfNotifications).stringValue;
    }
    _notiLabel.hidden = numberOfNotifications==0;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetMaxX(_thumbImageView.frame), self.bounds.size.height), point)) {
        return _thumbImageView;
    }
    return self;
}
@end
