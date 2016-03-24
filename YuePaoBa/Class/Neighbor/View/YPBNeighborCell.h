//
//  YPBNeighborCell.h
//  YuePaoBa
//
//  Created by Liang on 16/3/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBNeighborCell : UITableViewCell

@property (nonatomic,retain)UIImageView *userImgV;          //头像
@property (nonatomic,retain)UILabel *userNameDistance;      //昵称 距离
@property (nonatomic,retain)UILabel *userDetail;            //年龄  身高
@property (nonatomic,retain)UILabel *focus;                 //交友目的
@property (nonatomic,retain)UIButton *contactBtn;           //打招呼


- (void)setCellWithInfo:(NSString *)str;

@end
