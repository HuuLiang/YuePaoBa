//
//  YPBUserProfileViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserProfileViewController.h"
#import "YPBTableViewCell.h"
#import "YPBContact.h"
#import "YPBMessageViewController.h"
#import "YPBVIPPriviledgeViewController.h"

@interface YPBUserProfileViewController ()
{
    YPBTableViewCell *_wechatCell;
}
@end

@implementation YPBUserProfileViewController

- (instancetype)initWithUser:(YPBUser *)user {
    self = [self init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *nickName = self.user.nickName;
    
    if (nickName.length > 6) {
        NSMutableString *shortName = [NSMutableString string];
        [shortName appendString:[nickName substringWithRange:NSMakeRange(0, 3)]];
        [shortName appendString:@"..."];
        [shortName appendString:[nickName substringFromIndex:nickName.length-3]];
        nickName = shortName;
    }
    self.title = [nickName stringByAppendingString:@"的详细资料"];
    
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initCellLayouts];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (self->_wechatCell == cell) {
            if ([YPBUtil isVIP]) {
                if (self.user.isRegistered) {
                    [YPBMessageViewController showMessageForWeChatWithUser:self.user inViewController:self];
                } else {
                    [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
                }
            } else {
                YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeWeChatId];
                [self.navigationController pushViewController:vipVC animated:YES];
                
                [YPBStatistics logEvent:kLogUserWeChatViewedForPaymentEvent fromUser:[YPBUser currentUser].userId toUser:self.user.userId];
            }
        }
    };
}

- (void)initCellLayouts {
    NSUInteger detailInfoSection = 0;
    [self setHeaderHeight:15 inSection:detailInfoSection];

    NSUInteger row = 0;
    YPBTableViewCell *genderCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"female_icon"] title:@"性别：??"];
    genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    genderCell.imageView.image = self.user.gender==YPBUserGenderUnknown?nil:self.user.gender==YPBUserGenderFemale?[UIImage imageNamed:@"female_icon"]:[UIImage imageNamed:@"male_icon"];
    genderCell.titleLabel.text = self.user.gender==YPBUserGenderUnknown?nil:self.user.gender==YPBUserGenderFemale?@"性别：女":@"性别：男";
    [self setLayoutCell:genderCell inRow:row++ andSection:detailInfoSection];

    NSString *wechatTitle = @"微信：*******>>查看微信号";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:wechatTitle];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], NSUnderlineStyleAttributeName:@(1)} range:NSMakeRange(wechatTitle.length-6, 6)];
    
    _wechatCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"wechat_icon"] title:nil];
    _wechatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _wechatCell.titleLabel.attributedText = attrStr;
    [self setLayoutCell:_wechatCell inRow:row++ andSection:detailInfoSection];
    
    YPBTableViewCell *interestCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"interest_icon"] title:[NSString stringWithFormat:@"兴趣：%@", self.user.note ?: @"？？？"]];
    interestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:interestCell inRow:row++ andSection:detailInfoSection];
    
    YPBTableViewCell *professionCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"profession_icon"] title:[NSString stringWithFormat:@"职业：%@", self.user.profession ?: @"？？？"]];
    professionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:professionCell inRow:row++ andSection:detailInfoSection];
    
    detailInfoSection = 1;
    row = 0;
    [self setHeaderHeight:15 inSection:detailInfoSection];
    
    YPBTableViewCell *heightCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"height_icon"] title:[NSString stringWithFormat:@"身高：%@", self.user.heightDescription ?: @"???cm"]];
    heightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:heightCell inRow:row++ andSection:detailInfoSection];
    
    YPBTableViewCell *figureCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"figure_icon"] title:self.user.figureDescription ?: @"身材：?? ?? ??"];
    figureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:figureCell inRow:row++ andSection:detailInfoSection];

    YPBTableViewCell *ageCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"age_icon"] title:[NSString stringWithFormat:@"年龄：%@", self.user.ageDescription ?: @"？？"]];
    ageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:ageCell inRow:row++ andSection:detailInfoSection];

    detailInfoSection = 2;
    row = 0;
    [self setHeaderHeight:15 inSection:detailInfoSection];

    YPBTableViewCell *incomeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"income_icon"] title:[NSString stringWithFormat:@"月收入：%@", self.user.monthIncome ?: @"？？？"]];
    incomeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:incomeCell inRow:row++ andSection:detailInfoSection];

    YPBTableViewCell *assetsCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"assets_icon"] title:[NSString stringWithFormat:@"资产情况：%@", self.user.assets ?: @"？？？"]];
    assetsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:assetsCell inRow:row++ andSection:detailInfoSection];
    
    YPBTableViewCell *purposeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"purpose_icon"] title:[NSString stringWithFormat:@"交友目的：%@", [self.user.purpose isEqualToString:@"E夜情"] ? @"无所谓" : self.user.purpose]];
    purposeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:purposeCell inRow:row++ andSection:detailInfoSection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
