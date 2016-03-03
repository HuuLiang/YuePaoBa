//
//  YPBVideoMessagePollingView.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVideoMessagePollingView.h"
#import "YPBVideoMessagePollingCell.h"

@interface YPBVideoMessagePollingView () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSMutableArray<NSAttributedString *> *messages;
@property (nonatomic,retain,readonly) NSString *cellIdentifier;
@property (nonatomic,retain) NSMutableDictionary<NSString *, UIColor *> *nameColors;
@property (nonatomic,retain) NSTimer *fadingTimer;
@end

@implementation YPBVideoMessagePollingView

DefineLazyPropertyInitialization(NSMutableArray, messages)
DefineLazyPropertyInitialization(NSMutableDictionary, nameColors)

- (instancetype)init {
    self = [super init];
    if (self) {
        _messageRowHeight = 20;
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = _messageRowHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
        [self registerClass:[YPBVideoMessagePollingCell class] forCellReuseIdentifier:self.cellIdentifier];
    }
    return self;
}

- (void)setMessageRowHeight:(CGFloat)messageRowHeight {
    _messageRowHeight = messageRowHeight;
    self.rowHeight = messageRowHeight;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

- (void)insertMessages:(NSArray *)messages forNames:(NSArray *)names {
    [self.fadingTimer invalidate];
    self.fadingTimer = nil;
    
    if (self.alpha == 0) {
        [UIView animateWithDuration:1 animations:^{
            [self.messages removeAllObjects];
            [self reloadData];
            self.alpha = 1;
        }];
    }
    [messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *message = obj;
        NSString *name = @"";
        if (names.count > idx) {
            name = names[idx];
        }
        
        UIColor *nameColor = [self.nameColors objectForKey:name];
        if (!nameColor) {
            nameColor = [UIColor colorWithRed:(128+arc4random_uniform(128))/256. green:(128+arc4random_uniform(128))/256. blue:(128+arc4random_uniform(128))/256. alpha:1];
            [self.nameColors setObject:nameColor forKey:name];
        }
        
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] init];
        [attributedMessage appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:nameColor}]];
        [attributedMessage appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@", message] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        [self.messages addObject:attributedMessage];
    }];

    NSUInteger numberOfRows = [self numberOfRowsInSection:0];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (NSUInteger i = 0; i < messages.count; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:numberOfRows+i inSection:0]];
    }
    if (indexPaths.count > 0) {
        [UIView animateWithDuration:1 animations:^{
            [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    const CGFloat offsetY = self.messages.count * self.messageRowHeight - CGRectGetHeight(self.bounds);
    if (offsetY > 0) {
        [self setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    
    [self countDownFading];
}

- (void)countDownFading {
    @weakify(self);
    self.fadingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
        @strongify(self);
        if (!timer) {
            return ;
        }
        
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.messages removeAllObjects];
                [self reloadData];
                
                self.alpha = 1;
            }
        }];
    } repeats:NO];
}

- (NSString *)cellIdentifier {
    return @"VideoMessagePollingCellReusableIdentifier";
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBVideoMessagePollingCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.messages.count) {
        cell.titleLabel.attributedText = self.messages[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}
@end
