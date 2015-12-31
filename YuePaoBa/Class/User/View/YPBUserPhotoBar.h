//
//  YPBUserPhotoBar.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBPhotoBarSelectAction)(NSUInteger index);

@interface YPBUserPhotoBar : UIScrollView

@property (nonatomic,retain) NSArray<NSString *> *imageURLStrings;
@property (nonatomic,copy) YPBPhotoBarSelectAction selectAction;

@end
