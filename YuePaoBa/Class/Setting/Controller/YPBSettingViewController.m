//
//  YPBSettingViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBSettingViewController.h"
#import "YPBTableViewCell.h"
#import "YPBInputTextViewController.h"
#import "YPBWebViewController.h"
#import "YPBFeedbackModel.h"

@interface YPBSettingViewController ()
{
    YPBTableViewCell *_clearCacheCell;
    YPBTableViewCell *_questionCell;
    YPBTableViewCell *_agreementCell;
    YPBTableViewCell *_feedbackCell;
    YPBTableViewCell *_activityCell;
    YPBTableViewCell *_versionCell;
}
@property (nonatomic,retain) YPBFeedbackModel *feedbackModel;
@end

@implementation YPBSettingViewController

DefineLazyPropertyInitialization(YPBFeedbackModel, feedbackModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    self.layoutTableView.rowHeight = kScreenHeight*0.08;
    [self.view addSubview:self.layoutTableView];
    {
        [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self initCellLayouts];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_clearCacheCell) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"图片缓存清理成功" inViewController:self];
                [self reloadCacheSize];
            }];
        } else if (cell == self->_feedbackCell) {
            YPBInputTextViewController *inputVC = [[YPBInputTextViewController alloc] initWithTextBlock:YES];
            inputVC.title = @"意见反馈";
            inputVC.placeholder = @"输入反馈意见";
            inputVC.completeButtonTitle = @"发送";
            inputVC.changeHandler = ^BOOL(id sender, NSString *text) {
                return text.length > 0;
            };
            
            @weakify(self);
            inputVC.completionHandler = ^BOOL(id sender, NSString *text) {
                @strongify(self);
                YPBInputTextViewController *textVC = sender;
                if ([text isEqualToString:@"$$$UNBIND$$$"]) {
                    [UIAlertView bk_showAlertViewWithTitle:@"警告" message:@"是否确认接触手机的用户绑定？此操作将导致当前的用户无效！！！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [YPBUtil removeDeviceBinding];
                            exit(-1);
                        }
                    }];
                    return YES;
                } else if ([text isEqualToString:@"用户ID"]) {
                    [UIAlertView bk_showAlertViewWithTitle:@"您的用户ID为：" message:[YPBUser currentUser].userId cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        return;
                    }];
                }
                
                if(![text isEqualToString:@"用户ID"]) {
                    [textVC.view.window beginLoading];
                    [self.feedbackModel sendFeedback:text
                                              byUser:[YPBUser currentUser].userId
                               withCompletionHandler:^(BOOL success, id obj)
                     {
                         [textVC.view.window endLoading];
                         
                         if (success) {
                             [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"您的意见反馈已经发送成功" inViewController:self];
                             [textVC.navigationController popViewControllerAnimated:YES];
                         }
                     }];
                    return NO;
                }
                
                return YES;
            };
            [self.navigationController pushViewController:inputVC animated:YES];
        } else if (cell == self->_questionCell) {
            YPBWebViewController *webVC = [[YPBWebViewController alloc] initWithURL:[NSURL URLWithString:YPB_QANDA_URL]];
            webVC.title = @"常见问题";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_agreementCell) {
            YPBWebViewController *webVC = [[YPBWebViewController alloc] initWithURL:[NSURL URLWithString:YPB_AGREEMENT_URL]];
            webVC.title = @"用户协议";
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (cell == self->_activityCell) {
            YPBWebViewController *webVC = [[YPBWebViewController alloc] initWithURL:[NSURL URLWithString:YPB_ACTIVITY_URL]];
            webVC.title = @"活动相关";
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
    };
}

- (void)reloadCacheSize {
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    CGFloat mb = cacheSize / (1024. * 1024.);
    CGFloat kb = cacheSize / 1024.;
    
    NSString *sizeString;
    if (mb > 0) {
        sizeString = [NSString stringWithFormat:@"%.1fMB", mb];
    } else if (kb > 0) {
        sizeString = [NSString stringWithFormat:@"%.1fKB", kb];
    } else {
        sizeString = [NSString stringWithFormat:@"%ldB", (unsigned long)cacheSize];
    }
    
    _clearCacheCell.subtitleLabel.text = sizeString;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCacheSize];
}

- (void)initCellLayouts {
    [self setHeaderHeight:10 inSection:0];
    
    _clearCacheCell = [self cellWithCommonStylesAndTitle:@"清理图片缓存"];
    [self setLayoutCell:_clearCacheCell inRow:0 andSection:0];
    
    [self setHeaderHeight:10 inSection:1];
    
    _questionCell = [self cellWithCommonStylesAndTitle:@"常见问题"];
    [self setLayoutCell:_questionCell inRow:0 andSection:1];
    
    _agreementCell = [self cellWithCommonStylesAndTitle:@"用户协议"];
    [self setLayoutCell:_agreementCell inRow:1 andSection:1];
    
    _feedbackCell = [self cellWithCommonStylesAndTitle:@"意见反馈"];
    [self setLayoutCell:_feedbackCell inRow:2 andSection:1];
    
    _activityCell = [self cellWithCommonStylesAndTitle:@"活动相关"];
    [self setLayoutCell:_activityCell inRow:3 andSection:1];
}

- (YPBTableViewCell *)cellWithCommonStylesAndTitle:(NSString *)title {
    YPBTableViewCell *cell = [[YPBTableViewCell alloc] initWithImage:nil title:title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.font = [UIFont systemFontOfSize:14.];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
