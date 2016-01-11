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
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UILabel *_notiLabel;
}
@end

@implementation YPBContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];

        _notiLabel = [[UILabel alloc] init];
        _notiLabel.clipsToBounds = YES;
        _notiLabel.backgroundColor = [UIColor redColor];
        _notiLabel.textColor = [UIColor whiteColor];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.hidden = YES;
        [self addSubview:_notiLabel];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];

        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = kDefaultTextColor;
        [self addSubview:_subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat thumbHeight = lround(self.bounds.size.height * 0.8);
    const CGFloat thumbWidth = thumbHeight;
    const CGFloat thumbX = 30;
    const CGFloat thumbY = (self.bounds.size.height - thumbHeight) / 2;
    _thumbImageView.frame = CGRectMake(thumbX, thumbY, thumbWidth, thumbHeight);
    _thumbImageView.layer.cornerRadius = thumbHeight / 2;
    
    const CGFloat notiHeight = lround(self.bounds.size.height / 3);
    const CGFloat notiWidth = notiHeight;
    const CGFloat notiX = self.bounds.size.width - 15 - notiWidth;
    const CGFloat notiY = (self.bounds.size.height - notiHeight) / 2;
    _notiLabel.frame = CGRectMake(notiX, notiY, notiWidth, notiHeight);
    _notiLabel.layer.cornerRadius = notiHeight/2;
    _notiLabel.font = [UIFont boldSystemFontOfSize:notiHeight * 0.5];
    
    const CGFloat titleX = CGRectGetMaxX(_thumbImageView.frame)+15;
    const CGFloat titleWidth = CGRectGetMinX(_notiLabel.frame) - titleX - 15;
    const CGFloat titleHeight = lround(self.bounds.size.height * 0.2);
    const CGFloat titleY = self.bounds.size.height / 2 - titleHeight;
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    _titleLabel.font = [UIFont boldSystemFontOfSize:titleHeight];
    
    const CGFloat subtitleX = titleX;
    const CGFloat subtitleY = CGRectGetMaxY(_titleLabel.frame)+5;
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
@end
