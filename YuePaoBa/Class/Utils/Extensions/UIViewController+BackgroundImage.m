//
//  UIViewController+BackgroundImage.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/4.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "UIViewController+BackgroundImage.h"

static const void *kBackgroundImageViewAssociatedKey = &kBackgroundImageViewAssociatedKey;

@implementation UIViewController (BackgroundImage)

- (UIImageView *)backgroundImageView {
    UIImageView *imageView = objc_getAssociatedObject(self, kBackgroundImageViewAssociatedKey);
    if (imageView) {
        return imageView;
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                              self.view.bounds.size.width/2+CONTENT_VIEW_OFFSET_CENTERX,
                                                              self.view.bounds.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:imageView atIndex:0];
    objc_setAssociatedObject(self, kBackgroundImageViewAssociatedKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return imageView;
}
@end
