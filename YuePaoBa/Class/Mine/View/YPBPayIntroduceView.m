//
//  YPBPayIntroduceView.m
//  YuePaoBa
//
//  Created by Liang on 16/3/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPayIntroduceView.h"

@implementation YPBPayIntroduceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f1f5f8"];
        self.userInteractionEnabled = NO;
        [self layoutIntroduceView];
    }
    return self;
}


- (void)layoutIntroduceView {
    UIImageView *vipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_icon"]];
    [self addSubview:vipIcon];
    
    UILabel *topic = [[UILabel alloc] init];
    topic.text = @"功能介绍";
    topic.font = [UIFont systemFontOfSize:20];
    [self addSubview:topic];
    
    UITextView *detail = [[UITextView alloc] init];
    detail.backgroundColor = [UIColor colorWithHexString:@"f1f5f8"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.firstLineHeadIndent = 40;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"747171"]
                                 };
    detail.attributedText = [[NSAttributedString alloc] initWithString:@"1.VIP区尽情遨游；\n2.与所有嘉宾24小时无限制聊天；\n3.永远不限制打招呼的权力；\n4.可以出现在VIP区的特殊权利；\n5.拥有至高无上的VIP身份识别；\n6.微信,QQ,电话等私密联系方式随意查看!" attributes:attributes];
    [self addSubview:detail];
    [vipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(SCREEN_HEIGHT/50));
        make.left.equalTo(@(SCREEN_WIDTH/15));
    }];
    
    [topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vipIcon.mas_right).offset(SCREEN_WIDTH/35);
        make.centerY.equalTo(vipIcon.mas_centerY).offset(SCREEN_HEIGHT/240);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/30));
    }];
    
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(vipIcon.mas_bottom).offset(SCREEN_HEIGHT/60);
    }];
}
@end
