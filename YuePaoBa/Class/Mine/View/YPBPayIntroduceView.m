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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithHexString:@"f1f5f8"];
        self.userInteractionEnabled = NO;
        [self layoutIntroduceView];
    }
    return self;
}

- (void)layoutIntroduceView {
    UIImageView *vipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_icon"]];
    vipIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:vipIcon];
    
    UILabel *topic = [[UILabel alloc] init];
    topic.translatesAutoresizingMaskIntoConstraints = NO;
    topic.text = @"功能介绍";
    topic.font = [UIFont systemFontOfSize:20];
    [self addSubview:topic];
    
    UITextView *detail = [[UITextView alloc] init];
    detail.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    NSDictionary *laoutIntro = @{@"vip":vipIcon,
                                 @"topic":topic,
                                 @"detail":detail};
    NSDictionary *metrices = @{@"vipWidth":@(vipIcon.frame.size.width),
                               @"vipHeight":@(vipIcon.frame.size.height)};
    NSArray *contraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[vip(vipWidth)]-5-[topic]-100-|" options:0 metrics:metrices views:laoutIntro];
    NSArray *contraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[detail]-0-|" options:0 metrics:nil views:laoutIntro];
    NSArray *contraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[vip(vipHeight)]-5-[detail]-0-|" options:0 metrics:metrices views:laoutIntro];
    NSArray *contraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[topic(30)]-5-[detail]|" options:0 metrics:nil views:laoutIntro];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone4,1"] || (480 == self.frame.size.height)) {
        contraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[vip(vipHeight)]-0-[detail]-0-|" options:0 metrics:metrices views:laoutIntro];
        contraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topic(30)]-0-[detail]|" options:0 metrics:nil views:laoutIntro];
    }
    
    NSMutableArray * introArray = [[NSMutableArray alloc] init];
    [introArray addObjectsFromArray:contraints1];
    [introArray addObjectsFromArray:contraints2];
    [introArray addObjectsFromArray:contraints3];
    [introArray addObjectsFromArray:contraints4];
    [self addConstraints:introArray];
}

@end
