//
//  YPBPhotoBar.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBPhotoBar.h"
#import "YPBPhotoBarItemView.h"

#pragma mark - UIImageView+Lock

static const CGFloat kInterItemSpacing = 10;
//static const void *kLockImageAssociatedKey = &kLockImageAssociatedKey;
//
//@interface UIImageView (Lock)
//@property (nonatomic) BOOL isLocked;
////@property (nonatomic,retain) UIImageView *lockView;
//@end
//
//@implementation UIImageView (Lock)
//
////- (UIImageView *)lockView {
////    return objc_getAssociatedObject(self, kLockImageViewAssociatedKey);
////}
////
////- (void)setLockView:(UIImageView *)lockView {
////    objc_setAssociatedObject(self, kLockImageViewAssociatedKey, lockView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
////}
//
//- (BOOL)isLocked {
//    NSNumber *value = objc_getAssociatedObject(self, kLockImageAssociatedKey);
//    return value.boolValue;
//    //return [self.subviews containsObject:self.lockView];
//}
//
//- (void)setIsLocked:(BOOL)isLocked {
//    objc_setAssociatedObject(self, kLockImageAssociatedKey, @(isLocked), OBJC_ASSOCIATION_COPY_NONATOMIC);
////    if (isLocked) {
////        if (!self.lockView) {
////            self.lockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_lock"]];
////            [self addSubview:self.lockView];
////            {
////                [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
////                    make.center.equalTo(self);
////                    make.height.equalTo(self).multipliedBy(0.5);
////                    make.width.equalTo(self.lockView.mas_height);
////                }];
////            }
////        }
////    } else {
////        if (self.lockView) {
////            [self.lockView removeFromSuperview];
////            self.lockView = nil;
////        }
////    }
////    
//}
//
//@end

#pragma mark - YPBPhotoBar

@interface YPBPhotoBar ()
//@property (nonatomic,retain) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic,retain) NSMutableArray<YPBPhotoBarItemView *> *itemViews;
@property (nonatomic,retain) UILabel *emptyLabel;
//@property (nonatomic,retain) UIImageView *photoAddImageView;
@property (nonatomic,retain) YPBPhotoBarItemView *photoAddItemView;
@end

@implementation YPBPhotoBar

//DefineLazyPropertyInitialization(NSMutableArray, imageViews)
DefineLazyPropertyInitialization(NSMutableArray, itemViews)

- (instancetype)init {
    self = [super init];
    if (self) {
        _emptyLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _emptyLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _emptyLabel.font = [UIFont systemFontOfSize:16.];
        _emptyLabel.textColor = kDefaultTextColor;
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_emptyLabel];
        
        self.placeholder = @"TA的相册空空如也~~~";
    }
    return self;
}

- (instancetype)initWithUsePhotoAddItem:(BOOL)usePhotoAddItem {
    self = [self init];
    if (self) {
        _usePhotoAddItem = usePhotoAddItem;
        
        if (usePhotoAddItem) {
            [self.itemViews addObject:self.photoAddItemView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const NSUInteger itemCount = self.itemViews.count;
    _emptyLabel.hidden = itemCount > 0;
    
    const CGFloat itemHeight = CGRectGetHeight(self.bounds) - kInterItemSpacing * 2;
    
//    const CGFloat imageSize = CGRectGetHeight(self.bounds)-kInterItemSpacing*2;
//    self.contentSize = CGSizeMake(imageSize*imageCount+kInterItemSpacing*(imageCount+1), CGRectGetHeight(self.bounds));
    __block CGRect lastFrame = CGRectZero;
    [self.itemViews enumerateObjectsUsingBlock:^(YPBPhotoBarItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(CGRectGetMaxX(lastFrame)+kInterItemSpacing, kInterItemSpacing, [obj viewWidthRelativeToViewHeight:itemHeight], itemHeight);
        lastFrame = obj.frame;
    }];
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(lastFrame)+kInterItemSpacing, CGRectGetHeight(self.bounds));
}

//- (void)setImageURLStrings:(NSArray<NSString *> *)imageURLStrings {
//    _imageURLStrings = imageURLStrings;
//    
//    BOOL needsLayout = [self arrangeImageViewsWithCount:imageURLStrings.count];
//    NSParameterAssert(self.imageViews.count == imageURLStrings.count);
//    
//    @weakify(self);
//    [imageURLStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        UIImageView *imageView = self.imageViews[idx];
//        @weakify(imageView);
//        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]
//                     placeholderImage:nil
//                              options:SDWebImageAvoidAutoSetImage
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//        {
//            @strongify(self,imageView);
//            if (!self) {
//                return ;
//            }
//            
//            if (self.shouldLockAction && self.shouldLockAction(idx)) {
//                imageView.image = [image blurredImageWithRadius:kDefaultPhotoBlurRadius];
//                imageView.isLocked = YES;
//            } else {
//                imageView.image = image;
//                imageView.isLocked = NO;
//            }
//        }];
//    }];
//    
//    if (self.usePhotoAddItem) {
//        [self.imageViews insertObject:self.photoAddImageView atIndex:0];
//    }
//    
//    self.contentOffset = CGPointZero;
//    if (needsLayout) {
//        [self setNeedsLayout];
//    }
//}

- (void)setImageURLStrings:(NSArray<NSString *> *)imageURLStrings
              titleStrings:(NSArray<NSString *> *)titleStrings {
    _imageURLStrings = imageURLStrings;
    _titleStrings = titleStrings;
    
    BOOL needsLayout = [self arrangeItemViewsWithCount:imageURLStrings.count];//[self arrangeImageViewsWithCount:imageURLStrings.count];
    NSParameterAssert(self.itemViews.count == imageURLStrings.count);
    
    [self.itemViews enumerateObjectsUsingBlock:^(YPBPhotoBarItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.shouldLockAction && self.shouldLockAction(idx)) {
            obj.isLocked = YES;
        } else {
            obj.isLocked = NO;
        }
        
        obj.imageUrlString = imageURLStrings[idx];
        
        if (idx < titleStrings.count) {
            obj.title = titleStrings[idx];
        } else {
            obj.title = nil;
        }
    }];
//    [imageURLStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        self.itemViews[idx].
//        UIImageView *imageView = self.itemViews[idx].imageView;
//        @weakify(imageView);
//        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]
//                     placeholderImage:nil
//                              options:SDWebImageAvoidAutoSetImage
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//         {
//             @strongify(self,imageView);
//             if (!self) {
//                 return ;
//             }
//             
//             if (self.shouldLockAction && self.shouldLockAction(idx)) {
//                 imageView.image = [image blurredImageWithRadius:kDefaultPhotoBlurRadius];
//                 imageView.isLocked = YES;
//             } else {
//                 imageView.image = image;
//                 imageView.isLocked = NO;
//             }
//         }];
//    }];
    
    if (self.usePhotoAddItem) {
        [self.itemViews insertObject:self.photoAddItemView atIndex:0];
    }
    
    self.contentOffset = CGPointZero;
    if (needsLayout) {
        [self setNeedsLayout];
    }
}

- (void)setUsePhotoAddItem:(BOOL)usePhotoAddItem {
    _usePhotoAddItem = usePhotoAddItem;
    [self.itemViews insertObject:self.photoAddItemView atIndex:0];
    [self setNeedsLayout];
}

//- (UIImageView *)newImageView {
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.layer.cornerRadius = 5;
//    imageView.layer.masksToBounds = YES;
//    imageView.userInteractionEnabled = YES;
//    [imageView aspect_hookSelector:@selector(setImage:)
//                       withOptions:AspectPositionAfter
//                        usingBlock:^(id<AspectInfo> aspectInfo, UIImage *image)
//     {
//         UIImageView *thisImageView = [aspectInfo instance];
//         thisImageView.alpha = 0;
//         [UIView animateWithDuration:0.5 animations:^{
//             thisImageView.alpha = 1;
//         }];
//     } error:nil];
//    [self addSubview:imageView];
//    return imageView;
//}

- (YPBPhotoBarItemView *)newItemView {
    YPBPhotoBarItemView *itemView = [[YPBPhotoBarItemView alloc] init];
    [self addSubview:itemView];
    return itemView;
}

- (BOOL)arrangeItemViewsWithCount:(NSUInteger)newCount {
    if (_photoAddItemView) {
        [self.itemViews removeObject:_photoAddItemView];
    }
    
    const NSInteger diff = newCount - self.itemViews.count;
    
    if (diff < 0) {
        const NSInteger removeStartIndex = self.itemViews.count + diff;
        [self.itemViews enumerateObjectsUsingBlock:^(YPBPhotoBarItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= removeStartIndex) {
                [obj removeFromSuperview];
            } else {
                obj.image = nil;
                obj.title = nil;
            }
        }];
        
        [self.itemViews removeObjectsInRange:NSMakeRange(removeStartIndex, -diff)];
    } else {
        [self.itemViews enumerateObjectsUsingBlock:^(YPBPhotoBarItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.image = nil;
            obj.title = nil;
        }];
        
        for (NSInteger i = 0; i < diff; ++i) {
            [self.itemViews addObject:[self newItemView]];
        }
    }
    
    [self.itemViews enumerateObjectsUsingBlock:^(YPBPhotoBarItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @weakify(self);
        [obj.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull ges, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([ges isKindOfClass:[UITapGestureRecognizer class]] || [ges isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [obj removeGestureRecognizer:ges];
            }
        }];
        
        [obj bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock2(self.selectAction, idx, self);
        }];
        
        [obj addGestureRecognizer:[[UILongPressGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (state == UIGestureRecognizerStateBegan) {
                @strongify(self);
                SafelyCallBlock2(self.holdAction, idx, self);
            }
        }]];
    }];
    return diff != 0;
}

//- (BOOL)arrangeImageViewsWithCount:(NSUInteger)newCount {
//    if (_photoAddImageView) {
//        [self.imageViews removeObject:_photoAddImageView];
//    }
//    
//    const NSInteger diff = newCount - self.imageViews.count;
//    
//    if (diff < 0) {
//        const NSInteger removeStartIndex = self.imageViews.count + diff;
//        [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx >= removeStartIndex) {
//                [obj removeFromSuperview];
//            } else {
//                obj.image = nil;
//            }
//        }];
//        
//        [self.imageViews removeObjectsInRange:NSMakeRange(removeStartIndex, -diff)];
//    } else {
//        [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.image = nil;
//        }];
//        
//        for (NSInteger i = 0; i < diff; ++i) {
//            [self.imageViews addObject:[self newImageView]];
//        }
//    }
//    
//    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
//        @weakify(self);
//        [imageView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull ges, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([ges isKindOfClass:[UITapGestureRecognizer class]] || [ges isKindOfClass:[UILongPressGestureRecognizer class]]) {
//                [imageView removeGestureRecognizer:ges];
//            }
//        }];
//        
//        [imageView bk_whenTapped:^{
//            @strongify(self);
//            SafelyCallBlock2(self.selectAction, idx, self);
//        }];
//        
//        [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//            if (state == UIGestureRecognizerStateBegan) {
//                @strongify(self);
//                SafelyCallBlock2(self.holdAction, idx, self);
//            }
//        }]];
//    }];
//    return diff != 0;
//}

//- (UIImageView *)photoAddImageView {
//    if (_photoAddImageView) {
//        return _photoAddImageView;
//    }
//    
//    _photoAddImageView = [self newImageView];
//    _photoAddImageView.image = [UIImage imageNamed:@"add_photo_icon"];
//    _photoAddImageView.contentMode = UIViewContentModeCenter;
//    _photoAddImageView.backgroundColor = [UIColor lightGrayColor];
//    
//    @weakify(self);
//    [_photoAddImageView bk_whenTapped:^{
//        @strongify(self);
//        SafelyCallBlock1(self.photoAddAction, self);
//    }];
//    return _photoAddImageView;
//}

- (YPBPhotoBarItemView *)photoAddItemView {
    if (_photoAddItemView) {
        return _photoAddItemView;
    }
    
    _photoAddItemView = [[YPBPhotoBarItemView alloc] init];
    _photoAddItemView.imageView.image = [UIImage imageNamed:@"add_photo_icon"];
    _photoAddItemView.imageView.contentMode = UIViewContentModeCenter;
    _photoAddItemView.imageView.backgroundColor = [UIColor lightGrayColor];

    @weakify(self);
    [_photoAddItemView bk_whenTapped:^{
        @strongify(self);
        SafelyCallBlock1(self.photoAddAction, self);
    }];
    [self addSubview:_photoAddItemView];
    return _photoAddItemView;
}

- (BOOL)photoIsLocked:(NSUInteger)index {
    if (index < self.itemViews.count) {
        return self.itemViews[index].isLocked;
    }
    return NO;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _emptyLabel.text = placeholder;
}
@end
