//
//  YPBAvatarView.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBAvatarView.h"

static const CGSize kVIPIconSize = {24,30};

@interface YPBAvatarView ()
{
    UIImageView *_avatarImageView;
    UILabel *_nameLabel;
    
    UIImageView *_vipImageView;
}
@end

@implementation YPBAvatarView

- (instancetype)init {
    self = [super init];
    if (self) {
        _showName = YES;
        
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        {
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.equalTo(_avatarImageView.mas_width);
            }];
        }
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        {
            [self nameLabelRemakeConstraints];
        }
        
        _vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_icon"]];
        _vipImageView.hidden = YES;
        [self addSubview:_vipImageView];
        {
            [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(kVIPIconSize);
                make.right.bottom.equalTo(_avatarImageView);
            }];
        }
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    imageURL:(NSURL *)imageURL
                       isVIP:(BOOL)isVIP {
    self = [self init];
    if (self) {
        self.name = name;
        self.imageURL = imageURL;
        self.isVIP = isVIP;
    }
    return self;
}

- (void)nameLabelRemakeConstraints {
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(2);
        make.height.equalTo(self).multipliedBy(0.15);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _avatarImageView.layer.cornerRadius = CGRectGetWidth(_avatarImageView.frame) / 2;
    _nameLabel.font = [UIFont boldSystemFontOfSize:CGRectGetHeight(_nameLabel.frame)];
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    @weakify(self);
    [_avatarImageView sd_setImageWithURL:imageURL
                        placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        @strongify(self);
        self.image = image;
        
        if (self.avatarImageLoadHandler) {
            self.avatarImageLoadHandler(image);
        }
    }];
}

- (void)setIsVIP:(BOOL)isVIP {
    _isVIP = isVIP;
    _vipImageView.hidden = !isVIP;
    
}

- (void)setShowName:(BOOL)showName {
    _showName = showName;
    _nameLabel.hidden = !showName;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _avatarImageView.image = image ?: [UIImage imageNamed:@"avatar_placeholder"];
    _imageURL = nil;
}
@end
