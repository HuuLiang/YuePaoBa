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
@property (nonatomic,retain) UIImageView *photoAddImageView;
@end

@implementation YPBUserPhotoBar

DefineLazyPropertyInitialization(NSMutableArray, imageViews)

- (instancetype)init {
    self = [super init];
    if (self) {
        _emptyLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _emptyLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _emptyLabel.font = [UIFont systemFontOfSize:16.];
        _emptyLabel.textColor = kDefaultTextColor;
        _emptyLabel.text = @"TA的相册空空如也~~~";
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_emptyLabel];
    }
    return self;
}

- (instancetype)initWithUsePhotoAddItem:(BOOL)usePhotoAddItem {
    self = [self init];
    if (self) {
        _usePhotoAddItem = usePhotoAddItem;
        
        if (usePhotoAddItem) {
            [self.imageViews addObject:self.photoAddImageView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const NSUInteger imageCount = self.imageViews.count;
    _emptyLabel.hidden = imageCount > 0;
    
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
    
    if (self.usePhotoAddItem) {
        [self.imageViews insertObject:self.photoAddImageView atIndex:0];
    }
    
    self.contentOffset = CGPointZero;
    if (needsLayout) {
        [self setNeedsLayout];
    }
}

- (void)setUsePhotoAddItem:(BOOL)usePhotoAddItem {
    _usePhotoAddItem = usePhotoAddItem;
    [self.imageViews insertObject:self.photoAddImageView atIndex:0];
    [self setNeedsLayout];
}

- (UIImageView *)newImageView {
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
    return imageView;
}

- (BOOL)arrangeImageViewsWithCount:(NSUInteger)newCount {
    if (_photoAddImageView) {
        [self.imageViews removeObject:_photoAddImageView];
    }
    
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
            [self.imageViews addObject:[self newImageView]];
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

- (UIImageView *)photoAddImageView {
    if (_photoAddImageView) {
        return _photoAddImageView;
    }
    
    _photoAddImageView = [self newImageView];
    _photoAddImageView.image = [UIImage imageNamed:@"add_photo_icon"];
    _photoAddImageView.contentMode = UIViewContentModeCenter;
    _photoAddImageView.backgroundColor = [UIColor lightGrayColor];
    
    @weakify(self);
    [_photoAddImageView bk_whenTapped:^{
        @strongify(self);
        SafelyCallBlock1(self.photoAddAction, nil);
    }];
    return _photoAddImageView;
}
@end
