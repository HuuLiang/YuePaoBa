//
//  YPBRobotTableViewCell.m
//  YuePaoBa
//
//  Created by Liang on 16/5/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBRobotTableViewCell.h"
#import "XHMessageBubbleView.h"
#import "YPBUser.h"

@interface YPBRobotTableViewCell ()
{
    UIImageView *_view;
}
@end

@implementation YPBRobotTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    self.userInteractionEnabled = NO;
    return  self;
}

- (void)layoutWelcomeSubviewsWithInfo:(NSString *)imageUrl {
    _image = [[UIImageView alloc] init];
    [_image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    _image.layer.cornerRadius = 20.;
    _image.layer.masksToBounds = YES;
    [self addSubview:_image];
    
    
    UIImage *bublleImage = [UIImage imageNamed:@"weChatBubble_Receiving_Solid"];
    UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
    UIImage *edgeBubbleImage = XH_STRETCH_IMAGE(bublleImage, bubbleImageEdgeInsets);
    _view = [[UIImageView alloc] init];
    _view.userInteractionEnabled = YES;
    _view.image = edgeBubbleImage;
    [self addSubview:_view];
    
    UIImageView *currentUserImg = [[UIImageView alloc] init];
    if ([YPBUser currentUser].logoUrl.length > 0) {
        [currentUserImg sd_setImageWithURL:[NSURL URLWithString:[YPBUser currentUser].logoUrl]];
    }
    currentUserImg.backgroundColor = [UIColor cyanColor];
    [currentUserImg sd_setImageWithURL:[NSURL URLWithString:[YPBUser currentUser].logoUrl] placeholderImage:[UIImage imageNamed:@"avator"]];
    currentUserImg.layer.cornerRadius = 20.;
    currentUserImg.layer.masksToBounds = YES;
    [_view addSubview:currentUserImg];
    
    UILabel *labelA = [[UILabel alloc] init];
    labelA.font = [UIFont systemFontOfSize:13.];
//    labelA.backgroundColor = [UIColor yellowColor];
    labelA.text = @"恭喜您加入同城速配！\n在这里您可以大胆的交友,聊天！";
    labelA.numberOfLines = 0;
    [_view addSubview:labelA];
    
    UILabel *labelB = [[UILabel alloc] init];
    labelB.font = [UIFont systemFontOfSize:13.];
//    labelB.backgroundColor = [UIColor yellowColor];
    NSString * string = @"完善资料更容易得到有缘人的青睐哦！如您还有其他问题,可咨询客服QQ：\n咨询客服QQ:2686229951\n投诉客服QQ:3153715820 \n\n工作时间:\n每周一至周五10:00-18:00\n";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange ranggeA = [string rangeOfString:@"2686229951"];
    if (ranggeA.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"#30a6fa"] range:ranggeA];
    }
    NSRange ranggeB = [string rangeOfString:@"3153715820"];
    if (ranggeB.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"#30a6fa"] range:ranggeB];
    }
    labelB.attributedText = attributedStr;
    labelB.numberOfLines = 0;
    [_view addSubview:labelB];

    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_line"]];
    line.backgroundColor = [UIColor clearColor];
    [_view addSubview:line];

    _editCell = [[YPBTableViewCell alloc] init];
    _editCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _editCell.titleLabel.text = @"完善资料";
    _editCell.textLabel.textColor = [UIColor colorWithHexString:@"#30a6fa"];
    _editCell.titleLabel.font = [UIFont systemFontOfSize:13.];
//    _editCell.backgroundColor = [UIColor cyanColor];
    [_view addSubview:_editCell];
    
    
    {
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.top.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(40., 40.));
        }];
        
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_image.mas_right).offset(8);
            make.right.equalTo(self.mas_right).offset(-56);
            make.top.equalTo(self).offset(15);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }];
        
        [currentUserImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_view).offset(10);
            make.left.equalTo(_view).offset(18);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [labelA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(currentUserImg.mas_right).offset(5);
            make.top.equalTo(_view).offset(8);
            make.right.equalTo(_view).offset(-10);
//            make.height.equalTo(@(45));
        }];
        
        [labelB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view).offset(18);
            make.top.equalTo(labelA.mas_bottom).offset(5);
            make.right.equalTo(_view).offset(-10);
//            make.bottom.equalTo(_view.mas_bottom).offset(-50);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(_view);
            make.left.equalTo(_view).offset(8);
            make.right.equalTo(_view).offset(-3);
            make.top.equalTo(labelB.mas_bottom).offset(2);
            make.height.equalTo(@(2));
        }];

        [_editCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view).offset(10);
            make.right.equalTo(_view).offset(-10);
            make.top.equalTo(line.mas_bottom).offset(0);
            make.bottom.equalTo(_view.mas_bottom).offset(-5);
        }];
    }
}

- (void)layoutGreetSubviewsWithInfo:(NSString *)imageUrl count:(NSString *)count {
//    self.backgroundColor = [UIColor blueColor];
    
    _image = [[UIImageView alloc] init];
    [_image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    _image.layer.cornerRadius = 20.;
    _image.layer.masksToBounds = YES;
    [self addSubview:_image];
    
    
    UIImage *bublleImage = [UIImage imageNamed:@"weChatBubble_Receiving_Solid"];
    UIEdgeInsets bubbleImageEdgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
    UIImage *edgeBubbleImage = XH_STRETCH_IMAGE(bublleImage, bubbleImageEdgeInsets);
    _view = [[UIImageView alloc] init];
//    _view.backgroundColor = [UIColor whiteColor];
    _view.userInteractionEnabled = YES;
    _view.image = edgeBubbleImage;
    [self addSubview:_view];
    
    UIImageView *currentUserImg = [[UIImageView alloc] init];
    if ([YPBUser currentUser].logoUrl.length > 0) {
        [currentUserImg sd_setImageWithURL:[NSURL URLWithString:[YPBUser currentUser].logoUrl]];
    }
    currentUserImg.backgroundColor = [UIColor cyanColor];
    [currentUserImg sd_setImageWithURL:[NSURL URLWithString:[YPBUser currentUser].logoUrl] placeholderImage:[UIImage imageNamed:@"avator"]];
    currentUserImg.layer.cornerRadius = 20.;
    currentUserImg.layer.masksToBounds = YES;
    [_view addSubview:currentUserImg];
    
    UILabel *labelA = [[UILabel alloc] init];
    labelA.font = [UIFont systemFontOfSize:13.];
    NSString * string = [NSString stringWithFormat:@"您收到了%@个招呼哦！\n看看TA们是谁吧。",count];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange ranggeA = [string rangeOfString:count];
    if (ranggeA.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHexString:@"#30a6fa"] range:ranggeA];
    }
    labelA.attributedText = attributedStr;
    labelA.numberOfLines = 0;
    [_view addSubview:labelA];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_line"]];
    line.backgroundColor = [UIColor clearColor];
    [_view addSubview:line];
    
    _greetCell = [[YPBTableViewCell alloc] init];
    _greetCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _greetCell.titleLabel.text = @"点击查看";
    _greetCell.textLabel.textColor = [UIColor colorWithHexString:@"#30a6fa"];
    _greetCell.titleLabel.font = [UIFont systemFontOfSize:13.];
    //    _editCell.backgroundColor = [UIColor cyanColor];
    [_view addSubview:_greetCell];
    
    
    {
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.top.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(40., 40.));
        }];
        
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_image.mas_right).offset(8);
            make.right.equalTo(self.mas_right).offset(-56);
            make.top.equalTo(self).offset(15);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }];
        
        [currentUserImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_view).offset(10);
            make.left.equalTo(_view).offset(18);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
    
        [labelA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(currentUserImg.mas_right).offset(5);
            make.top.equalTo(_view).offset(8);
            make.right.equalTo(_view).offset(-10);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view).offset(8);
            make.right.equalTo(_view).offset(-3);
            make.top.equalTo(currentUserImg.mas_bottom).offset(3);
            make.height.equalTo(@(2));
        }];
        
        [_greetCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view).offset(10);
            make.right.equalTo(_view).offset(-10);
            make.top.equalTo(line.mas_bottom).offset(0);
            make.bottom.equalTo(_view.mas_bottom).offset(-5);
        }];
    }
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, 3);  //线宽
//    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);  //线的颜色
//    CGContextBeginPath(context);
//    
//    CGContextMoveToPoint(context, _view.frame.origin.x, 172);  //起点坐标
//    CGContextAddLineToPoint(context, _view.frame.size.width , 172);   //终点坐标
//    
//    CGContextStrokePath(context);
//}

@end
