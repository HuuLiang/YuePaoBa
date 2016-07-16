//
//  YPBPayIntroduceView.m
//  YuePaoBa
//
//  Created by Liang on 16/3/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPayIntroduceView.h"
#import "sys/utsname.h"

@implementation YPBPayIntroduceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
//        self.backgroundColor = [UIColor clearColor];
        [self layoutIntroduceView];
    }
    return self;
}

- (UIView *)createViewWithImage:(UIImage *)image string:(NSString *)str {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
//    UIView *serveView = [[UIView alloc] init];
//    serveView.userInteractionEnabled = YES;
//    serveView.layer.cornerRadius = 23;
//    serveView.layer.borderWidth = 0;
//    serveView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    serveView.layer.masksToBounds = YES;
//    [view addSubview:serveView];
    
    UIImageView *serveImg = [[UIImageView alloc] initWithImage:image];
    serveImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [view addSubview:serveImg];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:9.];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = str;
    label.numberOfLines = 0;
    [view addSubview:label];
    
    {
        [serveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(serveImg.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2 - 70, 30));
        }];
    }
    return view;
}

- (void)layoutIntroduceView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#ff6633"];
    [self addSubview:lineView];
    
    UILabel *notiLabel = [[UILabel alloc] init];
    notiLabel.text = @"  钻石VIP特权";
    notiLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    notiLabel.font = [UIFont systemFontOfSize:kScreenHeight * 24 / 1334.];
    notiLabel.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    [self addSubview:notiLabel];
    
    UIView * view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    [self addSubview:view];
    
    UIView *viewA = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_A"] string:@"私密照片全部解锁"];
    UIView *viewB = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_B"] string:@"私房视频即时观看"];
    
    UIView *smallline = [[UIView alloc] init];
    smallline.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
    [view addSubview:smallline];
    
    UIView *viewC = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_C"] string:@"24小时全时段聊天"];
    UIView *viewD = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_D"] string:@"手机、微信、QQ联系方式一个不落"];
    [view addSubview:viewA];
    [view addSubview:viewB];
    [view addSubview:viewC];
    [view addSubview:viewD];
    

    {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kScreenWidth * 10 / 750.);
            make.top.equalTo(self).offset(2);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 4 / 750., kScreenHeight * 30 / 1334.));
        }];
        
        [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right).offset(2);
            make.centerY.equalTo(lineView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, kScreenHeight * 30 / 1334.));
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(lineView.mas_bottom).offset(2);
        }];
    }
    
    {
        [viewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2., 50));
        }];
        
        [viewB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2., 50));
        }];
        
        [smallline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.right.equalTo(view);
            make.height.mas_equalTo(1);
        }];
        
        [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2., 50));
        }];
        
        [viewD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2., 50));
        }];
    }

//    UIImageView *vipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_icon"]];
//    [self addSubview:vipIcon];
//    
//    UILabel *topic = [[UILabel alloc] init];
//    topic.text = @"功能介绍";
//    topic.font = [UIFont systemFontOfSize:20];
//    [self addSubview:topic];
//    
//    UITextView *detail = [[UITextView alloc] init];
//    detail.backgroundColor = [UIColor colorWithHexString:@"f1f5f8"];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 2;
//    paragraphStyle.firstLineHeadIndent = 40;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                 NSParagraphStyleAttributeName:paragraphStyle,
//                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"747171"]
//                                 };
//    detail.attributedText = [[NSAttributedString alloc] initWithString:@"1.VIP区尽情遨游；\n2.与所有嘉宾24小时无限制聊天；\n3.永远不限制打招呼的权力；\n4.可以出现在VIP区的特殊权利；\n5.拥有至高无上的VIP身份识别；\n6.微信,QQ,电话等私密联系方式随意查看!" attributes:attributes];
//    [self addSubview:detail];
//    [vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(SCREEN_HEIGHT/50));
//        make.left.equalTo(@(SCREEN_WIDTH/15));
//    }];
//    
//    [topic mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(vipIcon.mas_right).offset(SCREEN_WIDTH/35);
//        make.centerY.equalTo(vipIcon.mas_centerY).offset(SCREEN_HEIGHT/240);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/30));
//    }];
//    
//    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self);
//        make.top.equalTo(vipIcon.mas_bottom).offset(SCREEN_HEIGHT/60);
//    }];
}
@end
