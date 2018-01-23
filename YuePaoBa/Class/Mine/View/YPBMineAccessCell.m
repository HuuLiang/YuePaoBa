//
//  YPBMineAccessCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBMineAccessCell.h"

@interface YPBMineAccessCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation YPBMineAccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = kDefaultTextColor;
        _subtitleLabel.numberOfLines = 2;
        [self addSubview:_subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat thumbX = 30;
    const CGFloat thumbHeight = lround(self.bounds.size.height * 0.8);
    const CGFloat thumbWidth = thumbHeight;
    const CGFloat thumbY = (self.bounds.size.height - thumbHeight) / 2;
    _thumbImageView.frame = CGRectMake(thumbX, thumbY, thumbWidth, thumbHeight);
    _thumbImageView.layer.cornerRadius = thumbHeight / 2;
    
    const CGFloat titleX = CGRectGetMaxX(_thumbImageView.frame) + 30;
    const CGFloat titleY = lround(CGRectGetHeight(self.bounds)/4);
    const CGFloat titleWidth = CGRectGetMaxX(self.bounds)-15-titleX;
    const CGFloat titleHeight = MAX(lround(CGRectGetHeight(self.bounds)*0.16), 14);
    _titleLabel.font = [UIFont systemFontOfSize:titleHeight];
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    CGSize subtitleSize = [_subtitleLabel.text sizeWithAttributes:@{NSFontAttributeName:_subtitleLabel.font}];
    const CGFloat subtitleX = titleX;
    const CGFloat subtitleY = CGRectGetMaxY(_titleLabel.frame)+lround(CGRectGetHeight(self.bounds)*0.05);
    const CGFloat subtitleWith = titleWidth;
    const CGFloat subtitleHeight = subtitleSize.height;
    _subtitleLabel.frame = CGRectMake(subtitleX, subtitleY, subtitleWith, subtitleHeight);
    _subtitleLabel.font = [UIFont systemFontOfSize:lround(_titleLabel.font.pointSize * 0.9)];
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
@end
