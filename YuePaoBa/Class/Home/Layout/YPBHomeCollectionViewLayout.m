//
//  YPBHomeCollectionViewLayout.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBHomeCollectionViewLayout.h"

static const CGFloat kThumbnailWidthToHeight = 1;

typedef NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> LayoutAttributesDictionary;

@interface YPBHomeCollectionViewLayout ()
@property (nonatomic,retain) LayoutAttributesDictionary *layoutAttributes;
@end

@implementation YPBHomeCollectionViewLayout

DefineLazyPropertyInitialization(LayoutAttributesDictionary, layoutAttributes)

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _interItemSpacing = 2;
//    }
//    return self;
//}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.layoutAttributes removeAllObjects];
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) {
        return ;
    }
    
    const CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    const CGFloat bigSize = (2*collectionViewWidth+(kThumbnailWidthToHeight-2)*self.interItemSpacing)/(3*kThumbnailWidthToHeight);
    const CGFloat smallSize = (bigSize - self.interItemSpacing) / 2;
    
    for (NSUInteger i = 0; i < numberOfItems; ++i) {
        UICollectionViewLayoutAttributes *layoutAttribs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        const CGFloat size = i % 9 == 0 ? bigSize : smallSize;
        
        CGFloat x = 0, y = 0;
        if (i % 9 == 0 || i % 9 == 1) {
            x = i % 9 == 0 ? 0 : bigSize + self.interItemSpacing;;
            y = (i / 9) * (bigSize + smallSize * 2 + self.interItemSpacing * 3);
        } else {
            x = i % 3 * (smallSize + self.interItemSpacing);
            y = (smallSize+self.interItemSpacing) * (i/3+i/9+1);
        }
        
        layoutAttribs.frame = CGRectMake(x, y, size, size);
        [self.layoutAttributes setObject:layoutAttribs forKey:layoutAttribs.indexPath];
    }
}

- (CGSize)collectionViewContentSize {
    __block CGFloat contentHeight = 0;
    [self.layoutAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UICollectionViewLayoutAttributes * _Nonnull obj, BOOL * _Nonnull stop) {
        if (key.row % 3 != 0) {
            return ;
        }
        
        const CGFloat itemHeight = CGRectGetHeight(obj.frame);
        contentHeight += itemHeight;
    }];
    
    contentHeight += self.interItemSpacing * (self.layoutAttributes.count / 3);
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), contentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.layoutAttributes.allValues bk_select:^BOOL(id obj) {
        UICollectionViewLayoutAttributes *attributes = obj;
        return CGRectIntersectsRect(rect, attributes.frame);
    }];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
}
@end
