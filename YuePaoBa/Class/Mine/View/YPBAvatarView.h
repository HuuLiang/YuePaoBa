//
//  YPBAvatarView.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBLoadAvatarImageCompletionHandler)(UIImage *image);

@interface YPBAvatarView : UIView

@property (nonatomic,retain) NSURL *imageURL;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL showName;
@property (nonatomic) BOOL isVIP;

@property (nonatomic,copy) YPBLoadAvatarImageCompletionHandler avatarImageLoadHandler;

- (instancetype)initWithName:(NSString *)name
                    imageURL:(NSURL *)imageURL
                       isVIP:(BOOL)isVIP;
@end
