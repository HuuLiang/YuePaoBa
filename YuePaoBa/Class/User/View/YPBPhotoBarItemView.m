//
//  YPBPhotoBarItemView.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPhotoBarItemView.h"

@interface YPBPhotoBarItemView ()

@end

@implementation YPBPhotoBarItemView
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [self init];
    if (self) {
        if (image) {
            self.imageView.image = image;
        }
        
        if (title) {
            self.titleLabel.text = title;
        }
    }
    return self;
}

- (instancetype)initWithImageUrlString:(NSString *)imageUrlString title:(NSString *)title {
    self = [self init];
    if (self) {
        if (imageUrlString) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
        }
        
        if (title) {
            self.titleLabel.text = title;
        }
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = 5;
    _imageView.layer.masksToBounds = YES;
    [_imageView aspect_hookSelector:@selector(setImage:)
                        withOptions:AspectPositionAfter
                         usingBlock:^(id<AspectInfo> aspectInfo, UIImage *image)
     {
         UIImageView *thisImageView = [aspectInfo instance];
         thisImageView.alpha = 0;
         [UIView animateWithDuration:0.5 animations:^{
             thisImageView.alpha = 1;
         }];
     } error:nil];
    [self addSubview:_imageView];
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:12.];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    return _titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_titleLabel == nil) {
        _imageView.frame = self.bounds;
    } else {
        _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
        
        const CGFloat titleY = CGRectGetMaxY(_imageView.frame)+5;
        _titleLabel.frame = CGRectMake(0, titleY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-titleY);
    }
}

- (CGFloat)viewWidthRelativeToViewHeight:(CGFloat)height {
    CGFloat titleHeight = _titleLabel ? _titleLabel.font.pointSize : 0;
    return height - titleHeight - 5;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (image == nil) {
        _imageView.image = nil;
    } else {
        self.imageView.image = image;
    }
}

- (void)setImageUrlString:(NSString *)imageUrlString {
    _imageUrlString = imageUrlString;
    @weakify(self);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
                      placeholderImage:nil
                               options:SDWebImageAvoidAutoSetImage
                             completed:^(UIImage *image,
                                         NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL)
     {
         @strongify(self);
         if (!self) {
             return ;
         }
         
         if (self.isLocked) {
             self.image = [image blurredImageWithRadius:kDefaultPhotoBlurRadius];
         } else {
             self.image = image;
         }
     }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title == nil) {
        _titleLabel.text = nil;
    } else {
        self.titleLabel.text = title;
    }
}
@end
