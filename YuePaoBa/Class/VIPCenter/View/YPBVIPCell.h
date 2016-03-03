//
//  YPBVIPCell.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBVIPCell : UITableViewCell

@property (nonatomic) NSUInteger level;
@property (nonatomic,retain) YPBUser *user;
@property (nonatomic,copy) YPBAction dateAction;
@property (nonatomic,copy) YPBAction likeAction;

@end
