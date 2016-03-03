//
//  YPBUserProfileCell.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBUserProfileCell : UITableViewCell

@property (nonatomic,retain) YPBUser *user;
@property (nonatomic) BOOL liked;
@property (nonatomic) NSUInteger numberOfLikes;

@property (nonatomic,copy) YPBAction dateAction;
@property (nonatomic,copy) YPBAction sendGiftAction;
@property (nonatomic,copy) YPBAction likeAction;

- (void)setLiked:(BOOL)liked animated:(BOOL)animated;

@end
