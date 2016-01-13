//
//  YPBPaymentPopView.m
//  YPBuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBPaymentPopView.h"

static const CGFloat kCellHeight = 70;
static const CGFloat kHeaderHeight = 50;
static const void *kPaymentPopViewAssociatedKey = &kPaymentPopViewAssociatedKey;
static const void *kPaymentButtonAssociatedKey = &kPaymentButtonAssociatedKey;

@interface YPBPaymentPopView () <UITableViewDataSource,UITableViewSeparatorDelegate>
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, UITableViewCell *> *cells;
@end

@implementation YPBPaymentPopView

DefineLazyPropertyInitialization(NSMutableDictionary, cells)

+ (instancetype)poppedViewOfSuperview:(UIView *)superview {
    return objc_getAssociatedObject(superview, kPaymentPopViewAssociatedKey);
}

+ (instancetype)popPaymentInView:(UIView *)superview {
    YPBPaymentPopView *popView = [self poppedViewOfSuperview:superview];
    if (!popView) {
        popView = [[YPBPaymentPopView alloc] init];
        objc_setAssociatedObject(superview, kPaymentPopViewAssociatedKey, popView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [popView showInView:superview];
    return popView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.hasSectionBorder = NO;
        self.hasRowSeparator = YES;
        self.separatorInset = UIEdgeInsetsZero;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)showInView:(UIView *)superview {
    if ([superview.subviews containsObject:self]) {
        return ;
    }
    
    [superview YPB_showMask];
    
    const CGFloat viewWidth = CGRectGetWidth(superview.bounds) * 0.9;
    const CGFloat viewHeight = [self viewHeightRelativeToWidth:viewWidth];
    const CGFloat viewX = (CGRectGetWidth(superview.bounds)-viewWidth)/2;
    const CGFloat viewY = (CGRectGetHeight(superview.bounds)-viewHeight)/2;
    
    self.alpha = 0;
    self.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    [superview addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    if (self.superview) {
        [self.superview YPB_hideMask];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            objc_setAssociatedObject(self.superview, kPaymentPopViewAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
            [self removeFromSuperview];
        }];
    }
}

- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width {
    __block CGFloat cellHeights = 0;
    [self.cells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UITableViewCell * _Nonnull obj, BOOL * _Nonnull stop) {
        cellHeights += [self tableView:self heightForRowAtIndexPath:key];
    }];
    
    cellHeights += [self tableView:self heightForHeaderInSection:0];
    return cellHeights+15;
}

- (void)addPaymentWithImage:(UIImage *)image
                      title:(NSString *)title
                  available:(BOOL)available
                     action:(YPBAction)action
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cells.count inSection:0];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_payment_button_background"]];
    [cell addSubview:backgroundView];
    {
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell).insets(UIEdgeInsetsMake(5, 10, 5, 10));
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [backgroundView addSubview:imageView];
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backgroundView);
            make.left.equalTo(backgroundView).offset(10);
            make.height.equalTo(backgroundView).multipliedBy(0.7);
            make.width.equalTo(imageView.mas_height);
        }];
    }
    
    UIButton *button;
    if (available) {
        button = [[UIButton alloc] init];
        objc_setAssociatedObject(cell, kPaymentButtonAssociatedKey, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIImage *image = [UIImage imageNamed:@"vip_payment_button_go_normal"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"vip_payment_button_go_highlight"] forState:UIControlStateHighlighted];
        [backgroundView addSubview:button];
        {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.right.height.equalTo(backgroundView);
                make.width.equalTo(button.mas_height).multipliedBy(image.size.width/image.size.height);
            }];
        }
        [button bk_addEventHandler:^(id sender) {
            if (action) {
                action(sender);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:lround(kScreenWidth*0.048)];
    titleLabel.text = title;
    [backgroundView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(backgroundView);
            make.right.equalTo(button?button.mas_left:backgroundView);
        }];
    }
    
    [self.cells setObject:cell forKey:indexPath];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *cellIndexPath = indexPath;
    if ([cellIndexPath class] != [NSIndexPath class]) {
        cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    }
    return self.cells[cellIndexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kHeaderHeight)];
    headerView.backgroundColor = tableView.backgroundColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_payment_header"]];
    const CGFloat height = kHeaderHeight / 2;
    const CGFloat width = height * imageView.image.size.width / imageView.image.size.height;
    imageView.frame = CGRectMake(0, kHeaderHeight/2, width, kHeaderHeight-height);
    [headerView addSubview:imageView];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"vip_payment_close"] forState:UIControlStateNormal];
    [headerView addSubview:closeButton];
    {
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView).offset(5);
            make.right.equalTo(headerView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
    @weakify(self);
    [closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self hide];
    } forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeaderHeight;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    __block UIView *hitView;
    [self.cells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UITableViewCell * _Nonnull obj, BOOL * _Nonnull stop) {
        CGPoint cellPoint = [self convertPoint:point toView:obj];
        if ([obj pointInside:cellPoint withEvent:event]) {
            hitView = objc_getAssociatedObject(obj, kPaymentButtonAssociatedKey);
            *stop = YES;
        }
    }];
    
    if (hitView) {
        return hitView;
    }
    return [super hitTest:point withEvent:event];
}
@end
