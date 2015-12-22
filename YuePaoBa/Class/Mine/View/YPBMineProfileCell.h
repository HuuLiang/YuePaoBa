//
//  YPBMineProfileCell.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPBProfileAction)(void);

@interface YPBMineProfileCell : UITableViewCell

@property (nonatomic,retain) UIImage *avatarImage;
@property (nonatomic) NSString *name;

@property (nonatomic,copy) YPBProfileAction viewFollowedAction;
@property (nonatomic,copy) YPBProfileAction viewFollowingAction;
@property (nonatomic,copy) YPBProfileAction viewAccessedAction;
@end
