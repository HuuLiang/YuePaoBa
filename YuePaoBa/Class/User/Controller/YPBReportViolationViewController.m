//
//  YPBReportViolationViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBReportViolationViewController.h"
#import "YPBReportViolationModel.h"
#import "YPBReportCell.h"

@interface YPBReportViolationViewController ()
@property (nonatomic,retain) YPBReportViolationModel *reportViolationModel;
@end

@implementation YPBReportViolationViewController

DefineLazyPropertyInitialization(YPBReportViolationModel, reportViolationModel)

- (instancetype)initWithUserId:(NSString *)userId {
    self = [self init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"举报";
    
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self initCellLayouts];
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        YPBReportCell *selectedCell = (YPBReportCell *)[self cellAtIndexPath:self.layoutTableView.indexPathForSelectedRow];
        if (!selectedCell) {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"请选择一条举报原因" inViewController:self];
            return ;
        }
        
        [self.reportViolationModel reportViolationWithContent:selectedCell.title userId:self.userId completionHandler:^(BOOL success, id obj) {
            if (success) {
                [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"举报成功" inViewController:self];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"举报失败" inViewController:self];
            }
        }];
        
    }];
}

- (void)initCellLayouts {
    [self setHeaderTitle:@"请选择举报原因" height:30 inSection:0];
    
    NSUInteger row = 0;
    [self setLayoutCell:[self newCellWithTitle:@"色情低俗"] inRow:row++ andSection:0];
    [self setLayoutCell:[self newCellWithTitle:@"广告骚扰"] inRow:row++ andSection:0];
    [self setLayoutCell:[self newCellWithTitle:@"政治敏感"] inRow:row++ andSection:0];
    [self setLayoutCell:[self newCellWithTitle:@"欺诈骗钱"] inRow:row++ andSection:0];
    [self setLayoutCell:[self newCellWithTitle:@"违法(暴力恐怖、违禁品等)"] inRow:row++ andSection:0];
    [self setLayoutCell:[self newCellWithTitle:@"信息冒用(名字、照片等冒用)"] inRow:row++ andSection:0];
}

- (YPBReportCell *)newCellWithTitle:(NSString *)title {
    YPBReportCell *cell = [[YPBReportCell alloc] initWithTitle:title];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
