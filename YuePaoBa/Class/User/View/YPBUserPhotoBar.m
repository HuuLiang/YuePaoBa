//
//  YPBUserPhotoBar.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserPhotoBar.h"

static const CGFloat kInterItemSpacing = 10;

@interface YPBUserPhotoBar ()
@property (nonatomic,retain) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic,retain) UILabel *emptyLabel;
@end

@implementation YPBUserPhotoBar

DefineLazyPropertyInitialization(NSMutableArray, imageViews)

- (instancetype)init {
    self = [super init];
    if (self) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.font = [UIFont systemFontOfSize:16.];
        _emptyLabel.textColor = kDefaultTextColor;
        _emptyLabel.text = @"TA的相册空空如也~~~";
        [self addSubview:_emptyLabel];
        {
            [_emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const NSUInteger imageCount = self.imageViews.count;
    const CGFloat imageSize = CGRectGetHeight(self.bounds)-kInterItemSpacing*2;
    self.contentSize = CGSizeMake(imageSize*imageCount+kInterItemSpacing*(imageCount+1), CGRectGetHeight(self.bounds));
    
    CGRect imageRect = CGRectMake(kInterItemSpacing, kInterItemSpacing, imageSize, imageSize);
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectOffset(imageRect, (imageSize+kInterItemSpacing)*idx, 0);
    }];
}

- (void)setImageURLStrings:(NSArray<NSString *> *)imageURLStrings {
    _imageURLStrings = imageURLStrings;
    
    BOOL needsLayout = [self arrangeImageViewsWithCount:imageURLStrings.count];
    NSParameterAssert(self.imageViews.count == imageURLStrings.count);

    [imageURLStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageViews[idx] sd_setImageWithURL:[NSURL URLWithString:obj]];
    }];
    
    self.contentOffset = CGPointZero;
    if (needsLayout) {
        [self setNeedsLayout];
    }
    
    if (imageURLStrings.count == 0) {
        self.emptyLabel.hidden = NO;
    } else {
        self.emptyLabel.hidden = YES;
    }
}

- (BOOL)arrangeImageViewsWithCount:(NSUInteger)newCount {
    const NSInteger diff = newCount - self.imageViews.count;
    
    if (diff < 0) {
        const NSInteger removeStartIndex = self.imageViews.count + diff;
        [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= removeStartIndex) {
                [obj removeFromSuperview];
            } else {
                obj.image = nil;
            }
        }];
        
        [self.imageViews removeObjectsInRange:NSMakeRange(removeStartIndex, -diff)];
    } else {
        [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.image = nil;
        }];
        
        for (NSInteger i = 0; i < diff; ++i) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView aspect_hookSelector:@selector(setImage:)
                               withOptions:AspectPositionAfter
                                usingBlock:^(id<AspectInfo> aspectInfo, UIImage *image)
            {
                UIImageView *thisImageView = [aspectInfo instance];
                thisImageView.alpha = 0;
                [UIView animateWithDuration:0.5 animations:^{
                    thisImageView.alpha = 1;
                }];
            } error:nil];
            [self addSubview:imageView];
            [self.imageViews addObject:imageView];
        }
    }
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @weakify(self);
        [obj bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock1(self.selectAction, idx);
        }];
    }];
    return diff != 0;
}
@end
