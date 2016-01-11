//
//  YPBAvatarView.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBAvatarView.h"

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
        
        _vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_icon"]];
        _vipImageView.hidden = YES;
        [self addSubview:_vipImageView];
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

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGFloat imageSize = lround(MIN(self.bounds.size.width, self.bounds.size.height));
    _avatarImageView.frame = CGRectMake(0, 0, imageSize, imageSize);
    _avatarImageView.layer.cornerRadius = imageSize / 2;
    
    const CGFloat nameWidth = self.bounds.size.width * 2;
    const CGFloat nameHeight = lround(self.bounds.size.height * 0.15);
    const CGFloat nameX = (self.bounds.size.width-nameWidth)/2;
    const CGFloat nameY = lround(CGRectGetMaxY(_avatarImageView.frame) + self.bounds.size.height*0.1);
    _nameLabel.frame = CGRectMake(nameX, nameY, nameWidth, nameHeight);
    _nameLabel.font = [UIFont boldSystemFontOfSize:nameHeight];
    
    const CGSize kVIPIconSize = {24,30};
    _vipImageView.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame)-kVIPIconSize.width,
                                     CGRectGetMaxY(_avatarImageView.frame)-kVIPIconSize.height,
                                     kVIPIconSize.width, kVIPIconSize.height);
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
