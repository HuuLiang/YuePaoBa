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
        
        [self layoutIntroduceView];
    }
    return self;
}

- (UIView *)createViewWithImage:(UIImage *)image string:(NSString *)str {
    UIView *view = [[UIView alloc] init];
    
    UIView *serveView = [[UIView alloc] init];
    serveView.userInteractionEnabled = YES;
    serveView.layer.cornerRadius = 23;
    serveView.layer.borderWidth = 1;
    serveView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    serveView.layer.masksToBounds = YES;
    [view addSubview:serveView];
    
    UIImageView *serveImg = [[UIImageView alloc] initWithImage:image];
    serveImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [serveView addSubview:serveImg];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:9.];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str;
    [view addSubview:label];
    
    {
        [serveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.centerY.equalTo(view).offset(-10);
            make.size.mas_equalTo(CGSizeMake(46, 46));
        }];
        
        [serveImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(serveView);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(serveView);
            make.top.equalTo(serveView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(100, 15));
        }];
    }
    return view;
}

- (void)layoutIntroduceView {
    UILabel *notiLabel = [[UILabel alloc] init];
    notiLabel.text = @"   钻石VIP特权";
    notiLabel.textColor = [UIColor grayColor];
    notiLabel.font = [UIFont systemFontOfSize:13.];
    notiLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:notiLabel];
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIView *viewA = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_A"] string:@"免费查看用户相册"];
    UIView *viewB = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_B"] string:@"免费查看用户视频"];
    UIView *viewC = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_C"] string:@"24小时与用户聊天"];
    UIView *viewD = [self createViewWithImage:[UIImage imageNamed:@"vip_payment_D"] string:@"免费查看联系方式"];
    [view addSubview:viewA];
    [view addSubview:viewB];
    [view addSubview:viewC];
    [view addSubview:viewD];
    

    {
        [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(2);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 15));
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(notiLabel.mas_bottom).offset(2);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    
    {
        [viewA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(view);
            make.width.equalTo(@(SCREEN_WIDTH/4));
        }];
        
        [viewB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewA.mas_right);
            make.top.bottom.equalTo(view);
            make.width.equalTo(@(SCREEN_WIDTH/4));
        }];
        
        [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewB.mas_right);
            make.top.bottom.equalTo(view);
            make.width.equalTo(@(SCREEN_WIDTH/4));
        }];
        
        [viewD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewC.mas_right);
            make.top.bottom.equalTo(view);
            make.width.equalTo(@(SCREEN_WIDTH/4));
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
