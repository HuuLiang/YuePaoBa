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
@property (nonatomic,retain) UIImage *placeholderImage;
@end

@implementation YPBAvatarView

- (UIImage *)placeholderImage {
    if (_placeholderImage) {
        return _placeholderImage;
    }
    
    _placeholderImage = [UIImage imageNamed:@"avatar_placeholder"];
    return _placeholderImage;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _showName = YES;
        
        _avatarImageView = [[UIImageView alloc] initWithImage:self.placeholderImage];
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
        
        @weakify(self);
        [_avatarImageView aspect_hookSelector:@selector(setImage:)
                                  withOptions:AspectPositionAfter
                                   usingBlock:^(id<AspectInfo> aspectInfo, UIImage *image)
        {
            @strongify(self);
            SafelyCallBlock1(self.avatarImageLoadHandler, image==self.placeholderImage?nil:image);
        } error:nil];
        
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
    
    [_avatarImageView sd_setImageWithURL:imageURL placeholderImage:self.placeholderImage options:SDWebImageRefreshCached|SDWebImageDelayPlaceholder];
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
