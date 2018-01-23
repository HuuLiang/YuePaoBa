//
//  YPBVideoGiftPollingView.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVideoGiftPollingView.h"
#import "YPBVideoGiftPollingCell.h"

@interface YPBVideoGiftPollingItem : NSObject
@property (nonatomic) NSURL *imageUrl;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *sender;
@end

@implementation YPBVideoGiftPollingItem

+ (instancetype)itemWithImageUrl:(NSURL *)imageUrl name:(NSString *)name sender:(NSString *)sender {
    YPBVideoGiftPollingItem *item = [[self alloc] init];
    item.imageUrl = imageUrl;
    item.name = name;
    item.sender = sender;
    return item;
}
@end

static NSString *const kGiftPollingCellReusableIdentifier = @"GiftPollingCellReusableIdentifier";

@interface YPBVideoGiftPollingView () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSMutableArray<YPBVideoGiftPollingItem *> *items;
@property (nonatomic,retain) NSTimer *fadingTimer;
@end

@implementation YPBVideoGiftPollingView

DefineLazyPropertyInitialization(NSMutableArray, items)

- (instancetype)init {
    self = [super init];
    if (self) {
        _giftRowHeight = 40;
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.scrollEnabled = NO;
        self.rowHeight = _giftRowHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
        [self registerClass:[YPBVideoGiftPollingCell class] forCellReuseIdentifier:kGiftPollingCellReusableIdentifier];
    }
    return self;
}

- (void)pollGiftWithImageUrl:(NSURL *)imageUrl name:(NSString *)name sender:(NSString *)sender {
    [self.fadingTimer invalidate];
    self.fadingTimer = nil;
    
    if (self.alpha == 0) {
        [self.items removeAllObjects];
        [self reloadData];
        self.alpha = 1;
    }
    
    [self.items addObject:[YPBVideoGiftPollingItem itemWithImageUrl:imageUrl name:name sender:sender]];
    
    [UIView animateWithDuration:1 animations:^{
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    const CGFloat offsetY = self.items.count * self.giftRowHeight - CGRectGetHeight(self.bounds);
    [self setContentOffset:CGPointMake(0, offsetY) animated:YES];
    
    [self countDownFading];
}

- (void)countDownFading {
    @weakify(self);
    self.fadingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:10 block:^(NSTimer *timer) {
        @strongify(self);
        if (!timer) {
            return ;
        }
        
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished && self.alpha == 0) {
                [self.items removeAllObjects];
                [self reloadData];
                
                self.alpha = 1;
            }
        }];
    } repeats:NO];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBVideoGiftPollingCell *cell = [tableView dequeueReusableCellWithIdentifier:kGiftPollingCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.items.count) {
        YPBVideoGiftPollingItem *item = self.items[indexPath.row];
        [cell setGiftImageUrl:item.imageUrl name:item.name sender:item.sender];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
