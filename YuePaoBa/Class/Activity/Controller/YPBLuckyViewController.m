//
//  YPBLuckyViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/8/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLuckyViewController.h"
#import "YPBWebViewController.h"
#import "YPBLuckyNoticeView.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBWinnerView.h"
#import "YPBUserVIPUpgradeModel.h"

const static CGFloat ANIM_TIME = 5.0; // 动画时间
const static CGFloat ROTATION_EXTEND = 20; // 旋转圈数延长 // 2 * M_PI = 1圈
const static NSInteger ITEM_COUNT = 8; // 转盘等比分割

#define luckyCellHeight kScreenWidth * 1556/ 750 * 0.68 + kWidth(400) + kWidth(90)

@interface YPBLuckyViewController ()
{
    UIImageView *_imageRound;
    UIImageView *_pointerImgV;
    float random; // 位置，demo中从0开始
    float orign; // 角度
    NSTimer *_timer;
    NSInteger _count;
    UITableViewCell *_luckyCell;
    UITableViewCell *_protocolCell;
}
@property (nonatomic) NSMutableArray *userNames;
@property (nonatomic) NSArray *prizeTitles;
@property (nonatomic) YPBUserVIPUpgradeModel *VipUpdateModel;
@end

@implementation YPBLuckyViewController
DefineLazyPropertyInitialization(YPBUserVIPUpgradeModel, VipUpdateModel)

- (void)viewDidLoad {
    [super viewDidLoad];

    _count = 0;
    _userNames = [[NSMutableArray alloc] initWithArray:[YPBSystemConfig sharedConfig].userNames];
    _prizeTitles = @[@"一个月会员卡",@"一季度会员卡",@"一年会员卡",@"ipad Mini",@"iphone",@"10元话费",@"50元话费",@"100元话费"];
    
    
    self.layoutTableView.hasRowSeparator = NO;
    self.layoutTableView.hasSectionBorder = NO;
    self.layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#f52c3e"];
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.layoutTableView.contentSize = CGSizeMake(kScreenWidth, kScreenWidth * 1556 / 750 + 500);
    
    UIImageView *_bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lucky.jpg"]];
    [self.layoutTableView insertSubview:_bgImgV atIndex:0];
    
    {
        [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.layoutTableView);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(kScreenWidth * 1556 / 750.);
        }];
    }
    
    [self initCells];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_protocolCell) {
            YPBWebViewController *webVC = [[YPBWebViewController alloc] initWithURL:[NSURL URLWithString:KactivityProtocolUrl]];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    if (!_timer) {
        /**
         *  import
         *  默认状态下定时器会在视图滚动暂停 so 用下面的方法创建定时器
         */
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(checkCount) userInfo:nil repeats:YES];
        _timer = [NSTimer timerWithTimeInterval:0.6 target:self selector:@selector(checkCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    if (_userNames.count > 0) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCells {
    [self removeAllLayoutCells];
    
    NSUInteger section = 0;
    
    [self initDialCellInSection:section++];
    [self initLuckyUsersTitleInSection:section++];
    [self initLuckyUsersInSection:section++];
    [self initProtocolCellInSection:section];
    
    [self.layoutTableView reloadData];
}

- (void)initDialCellInSection:(NSUInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    _imageRound = [UIImageView new];
    _imageRound.image = [UIImage imageNamed:@"activity_dial_icon"];
    _imageRound.userInteractionEnabled = YES;
    _imageRound.translatesAutoresizingMaskIntoConstraints = NO;
    _imageRound.transform = CGAffineTransformMakeRotation(M_PI/8.);
    [cell addSubview:_imageRound];
    {
        [_imageRound mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell);
            make.bottom.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kScreenWidth * 0.8));
        }];
    }
    
    _pointerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_pointer_icon"]];
    
        _pointerImgV.userInteractionEnabled = YES;
    [cell addSubview:_pointerImgV];
    {
        [_pointerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell);
            make.centerY.equalTo(cell.mas_bottom).offset(-kScreenWidth * 0.45);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.4, kScreenWidth * 0.4));
        }];
    }
    @weakify(self);
    [_pointerImgV bk_whenTapped:^{
        @strongify(self);
        [self touchPointer];
    }];
    
    [self setLayoutCell:cell cellHeight:kScreenWidth * 1556/ 750 * 0.68 inRow:0 andSection:section];
}

- (void)touchPointer {
    if (dialCount > 0) {
        setDialCount(dialCount-1);
        
        orign = 0.0f;
        [_imageRound.layer removeAllAnimations];
        _imageRound.transform = CGAffineTransformMakeRotation(M_PI/8.);
        
        NSInteger arcRan = arc4random() % 100 + 1;
        
        if (arcRan >= 1 && arcRan < 80) {
            random = 3;
        } else if (arcRan >= 80 && arcRan < 90) {
            random = 5;
        } else {
            random = 1;
        }
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setFromValue:[NSNumber numberWithFloat:M_PI/8.]];
        orign = 2 - random / ITEM_COUNT * 2;
        [anim setToValue:[NSNumber numberWithFloat:M_PI * (ROTATION_EXTEND + orign)+ M_PI/8.]];
        anim.duration = ANIM_TIME;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        [anim setDelegate:self];
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [_imageRound.layer addAnimation:anim forKey:@"rotation"];
    } else{
        @weakify(self);
        [self.view beginLoading];
        YPBLuckyNoticeView *notiView = [[YPBLuckyNoticeView alloc] init];
        [self.view addSubview:notiView];
        
        [notiView.closeBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            [notiView removeFromSuperview];
            [self.view endLoading];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [notiView.payBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymnetContentTypeActivity];
            [self.navigationController pushViewController:vipVC animated:YES];
            [notiView removeFromSuperview];
            [self.view endLoading];
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [notiView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(kWidth(569), kWidth(590)));
            }];
        }
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    _pointerImgV.userInteractionEnabled = NO;

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _pointerImgV.userInteractionEnabled = YES;
    DLog(@"%f",random);
    
    NSUInteger months = 0;
    if (random == YPBLuckyTypeMonth) {
        months = 1;
    } else if (random == YPBLuckyTypeSeason) {
        months = 3;
    } else if (random == YPBLuckyTypeYear) {
        months = 12;
    }
    
    NSString *vipExpireTime = [YPBUtil renewVIPByMonths:months];
    [self.VipUpdateModel upgradeToVIPWithExpireTime:vipExpireTime completionHandler:nil];
    
    [self.view beginLoading];
    YPBWinnerView *winnerView = [[YPBWinnerView alloc] initWithType:random];
    [self.view addSubview:winnerView];
    @weakify(self);
    [winnerView.repeatBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self.view endLoading];
        [winnerView removeFromSuperview];
        [self touchPointer];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [winnerView.closeImgV bk_whenTapped:^{
        @strongify(self);
        [self.view endLoading];
        [winnerView removeFromSuperview];
    }];
    
    {
        [winnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kWidth(468), kWidth(409)));
        }];
    }
}

- (void)initLuckyUsersTitleInSection:(NSUInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"获奖名单公示";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#ffffff"];
    label.font = [UIFont systemFontOfSize:kWidth(42)];
    [cell addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(cell);
            make.height.mas_equalTo(kWidth(45));
        }];
    }
    [self setLayoutCell:cell cellHeight:kWidth(90) inRow:0 andSection:section];
}

- (void)initLuckyUsersInSection:(NSUInteger)section {
    _luckyCell = [[UITableViewCell alloc] init];
    _luckyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _luckyCell.backgroundColor = [UIColor clearColor];
    
    [self setLayoutCell:_luckyCell cellHeight:kWidth(400) inRow:0 andSection:section];
}

- (void)checkCount {
    if (_count == _userNames.count - 1) {
        [self scrollUserNames:_count];
        _count = 0;
    } else if (_count < _userNames.count -1) {
        [self scrollUserNames:_count];
        _count++;
    }
}

- (void)scrollUserNames:(NSInteger)count{
        DLog("%ld %ld",_userNames.count,_count);
    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    vipLabel.backgroundColor = [UIColor clearColor];
    vipLabel.textAlignment = NSTextAlignmentCenter;
    NSString *string = [NSString stringWithFormat:@"%@刚刚抽到了%@",[YPBSystemConfig sharedConfig].userNames[count],_prizeTitles[_count % 8]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange rangge = [string rangeOfString:[YPBSystemConfig sharedConfig].userNames[count]];
    if (rangge.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor whiteColor ] range:rangge];
    }
    vipLabel.attributedText = attributedStr;
    vipLabel.frame = CGRectMake(5, kWidth(400), kScreenWidth - 10, kWidth(32));
    [_luckyCell addSubview:vipLabel];
    
    
    [UIView animateWithDuration:3.5 delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         vipLabel.transform = CGAffineTransformMakeTranslation(0, -kWidth(400));
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              vipLabel.transform = CGAffineTransformMakeTranslation(0, -kWidth(400));
                                              vipLabel.alpha = 0.1;
                                          } completion:^(BOOL finished) {
                                              [vipLabel removeFromSuperview];
                                          }];
                     }];
}

- (void)initProtocolCellInSection:(NSUInteger)section {
    _protocolCell = [[UITableViewCell alloc] init];
    _protocolCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _protocolCell.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text =@"奥运大转盘规则";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kWidth(42)];
    label.textColor = [UIColor colorWithHexString:@"#ffffff"];
    label.backgroundColor = [UIColor clearColor];
    [_protocolCell addSubview:label];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_into_icon"]];
    [_protocolCell addSubview:imgV];
    
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_protocolCell);
            make.top.equalTo(_protocolCell).offset(kWidth(50));
            make.height.mas_equalTo(kWidth(50));
        }];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(kWidth(10));
            make.centerX.equalTo(_protocolCell);
            make.size.mas_equalTo(CGSizeMake(kWidth(66*0.8), kWidth(70*0.8)));
        }];
    }
    
    [self setLayoutCell:_protocolCell cellHeight:kWidth(170) inRow:0 andSection:section];
}

@end
