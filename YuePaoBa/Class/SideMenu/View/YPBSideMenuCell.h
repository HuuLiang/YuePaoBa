//
//  YPBSideMenuCell.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBSideMenuCell : UITableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *iconImage;

- (instancetype)initWithTitle:(NSString *)title iconImage:(UIImage *)iconImage;

@end
