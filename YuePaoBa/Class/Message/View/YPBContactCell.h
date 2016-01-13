//
//  YPBContactCell.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBContactCell : UITableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSUInteger numberOfNotifications;

@property (nonatomic,copy) YPBAction avatarTapAction;
@property (nonatomic,copy) YPBAction notificationTapAction;

@end
