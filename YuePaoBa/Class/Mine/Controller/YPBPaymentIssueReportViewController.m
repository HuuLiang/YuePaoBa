//
//  YPBPaymentIssueReportViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPaymentIssueReportViewController.h"
#import "YPBTableViewCell.h"
#import "YPBInputTextViewController.h"
#import <ActionSheetStringPicker.h>
#import "YPBFeedbackModel.h"
#import "YPBTickCell.h"

@interface YPBPaymentIssueReportViewController ()
{
    YPBTableViewCell *_paymentTypeCell;
    YPBTableViewCell *_orderCell;
    YPBTableViewCell *_serveCell;
    
    YPBTableViewCell *_otherIssueCell;
}
@property (nonatomic,retain) YPBFeedbackModel *feedbackModel;
@property (nonatomic,retain) YPBTickCell *tickedCell;
@end

@implementation YPBPaymentIssueReportViewController

DefineLazyPropertyInitialization(YPBFeedbackModel, feedbackModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付问题反馈";
    
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self initCellLayouts];
    
    @weakify(self);
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (cell == self->_paymentTypeCell) {
            [self onPaymentCell];
        } else if (cell == self->_orderCell) {
            [self onOrderCell];
        } else if (cell == self->_serveCell) {
            [self onServeCell];
        } else if (indexPath.section == 1) {
            [self onIssueCell:cell atIndexPath:indexPath];
        }
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交"
                                                                                 style:UIBarButtonItemStyleDone
                                                                               handler:^(id sender)
    {
        @strongify(self);
        NSString *paymentType = self->_paymentTypeCell.subtitleLabel.text;
        if (paymentType.length == 0) {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"您还未选择支付类型" inViewController:self];
            return ;
        }
        
        NSString *order = self->_orderCell.subtitleLabel.text;
        if (order.length == 0) {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"您还未填写订单号" inViewController:self];
            return ;
        }
        
        NSString *feedback = self.tickedCell ? self.tickedCell.title : self->_otherIssueCell.subtitleLabel.text;
        if (feedback.length == 0) {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"您还未选择或者填写问题描述" inViewController:self];
            return ;
        }
        
        NSString *content = [NSString stringWithFormat:@"PaymentType:%@\nOrderNo:%@\nPaymentIssue:%@", paymentType, order, feedback];
        [self.feedbackModel sendFeedback:content byUser:[YPBUser currentUser].userId withCompletionHandler:^(BOOL success, id obj) {
            if (success) {
                [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"成功提交支付问题" inViewController:self];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"提交支付问题失败" inViewController:self];
            }
        }];
    }];
}

- (void)initCellLayouts {
    NSUInteger row = 0;
    _paymentTypeCell = [self newCellWithTitle:@"支付类型"];
    _paymentTypeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setLayoutCell:_paymentTypeCell inRow:row++ andSection:0];
    
    _orderCell = [self newCellWithTitle:@"订单号"];
    _orderCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setLayoutCell:_orderCell inRow:row++ andSection:0];
    
    _serveCell = [self newCellWithTitle:@"咨询客服"];
    _serveCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setLayoutCell:_serveCell inRow:row++ andSection:0];
    
    [self setHeaderTitle:@"问题描述" height:30 inSection:1];
    
    row = 0;
    YPBTickCell *issueCell1 = [[YPBTickCell alloc] init];
    issueCell1.title = @"付了款但是显示付款失败";
    [self setLayoutCell:issueCell1 inRow:row++ andSection:1];
    
    _otherIssueCell = [self newCellWithTitle:@"其它问题"];
    _otherIssueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setLayoutCell:_otherIssueCell inRow:row++ andSection:1];
}

- (YPBTableViewCell *)newCellWithTitle:(NSString *)title {
    YPBTableViewCell *cell = [[YPBTableViewCell alloc] initWithImage:nil title:title];
    cell.titleLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)onPaymentCell {
    @weakify(self);
    NSArray *rows = @[@"支付宝",@"微信客户端支付"];
    NSUInteger index = [rows indexOfObject:_paymentTypeCell.subtitleLabel.text];
    [ActionSheetStringPicker showPickerWithTitle:@"选择支付类型"
                                            rows:rows
                                initialSelection:index==NSNotFound?0:index
                                       doneBlock:^(ActionSheetStringPicker *picker,
                                                   NSInteger selectedIndex,
                                                   id selectedValue)
    {
        @strongify(self);
        self->_paymentTypeCell.subtitleLabel.text = selectedValue;
    } cancelBlock:nil origin:self.view];
}

- (void)onOrderCell {
    @weakify(self);
    YPBInputTextViewController *textVC = [[YPBInputTextViewController alloc] initWithTextBlock:NO];
    textVC.title = @"订单号";
    textVC.placeholder = @"输入订单号";
    textVC.text = _orderCell.subtitleLabel.text;
    textVC.completeButtonTitle = @"确定";
    textVC.completionHandler = ^BOOL(id sender, NSString *text) {
        @strongify(self);
        self->_orderCell.subtitleLabel.text = text;
        return YES;
    };
    [self.navigationController pushViewController:textVC animated:YES];
}

- (void)onServeCell {
    [UIAlertView bk_showAlertViewWithTitle:@"咨询客服QQ:2686229951\n投诉客服QQ:3153715820" message:@"工作时间:每周一至周五10:00-18:00" cancelButtonTitle:@"确定" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}

- (void)onIssueCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (cell == _otherIssueCell) {
        @weakify(self);
        YPBInputTextViewController *textVC = [[YPBInputTextViewController alloc] initWithTextBlock:YES];
        textVC.title = @"问题描述";
        textVC.placeholder = @"输入问题描述";
        textVC.text = _otherIssueCell.subtitleLabel.text;
        textVC.completeButtonTitle = @"确定";
        textVC.completionHandler = ^BOOL(id sender, NSString *text) {
            @strongify(self);
            self->_otherIssueCell.subtitleLabel.text = text;
            
            if (text.length > 0) {
                self.tickedCell.ticked = NO;
                self.tickedCell = nil;
            }
            return YES;
        };
        [self.navigationController pushViewController:textVC animated:YES];
    } else {
        self.tickedCell = (YPBTickCell *)cell;
        self.tickedCell.ticked = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
