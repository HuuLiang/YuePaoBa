//
//  YPBPayCell.h
//  YuePaoBa
//
//  Created by Liang on 16/3/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBPayCell : UITableViewCell

@property (nonatomic,retain) UIImageView * backgroundImage;
@property (nonatomic,retain) UILabel * priceLabel;
@property (nonatomic,retain) UILabel * detailLabel;
@property (nonatomic,retain) UIButton * payButton;
@property (nonatomic,retain) NSString *monthTime;

- (void)setCellInfoWithPrice:(NSString*)price Month:(NSString *)monthInfo;

@end
