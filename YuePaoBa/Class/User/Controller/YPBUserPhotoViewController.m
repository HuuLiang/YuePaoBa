//
//  YPBUserPhotoViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserPhotoViewController.h"
#import "YPBPhotoBarrageModel.h"

@interface YPBUserPhotoViewController ()
@property (nonatomic,retain) YPBPhotoBarrageModel *barrageModel;
@property (nonatomic,retain) NSMutableArray<UILabel *> *barrageLabels;
@end

@implementation YPBUserPhotoViewController

DefineLazyPropertyInitialization(YPBPhotoBarrageModel, barrageModel)
DefineLazyPropertyInitialization(NSMutableArray, barrageLabels)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    self.displayAction = ^(NSUInteger index) {
        @strongify(self);
        [self loadBarragesAtIndex:index];
    };
}

- (void)loadBarragesAtIndex:(NSUInteger)index {
    [self.barrageLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.barrageLabels removeAllObjects];
    
    if (self.photos.count == 0 || index >= self.photos.count) {
        return ;
    }
    
    @weakify(self);
    YPBUserPhoto *photo = self.photos[index];
    [self.barrageModel fetchBarrageWithPhotoId:photo.id completionHandler:^(BOOL success, id obj) {
        @strongify(self);
        
        if (self && success) {
            [self fireBarrages:obj];
        }
    }];
}

- (void)fireBarrages:(NSArray<NSString *> *)barrages {
    
    const CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    const CGFloat topBottomInsets = 50;
    
    [barrages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const CGFloat y = arc4random_uniform(viewHeight-topBottomInsets*2)+topBottomInsets;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = obj;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16.];
        [self.barrageLabels addObject:label];
        [self.view addSubview:label];
        {
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_right);
                make.top.equalTo(self.view).offset(y);
            }];
            [self.view layoutIfNeeded];
        }
        
        [UIView animateWithDuration:5+arc4random_uniform(5) delay:idx options:UIViewAnimationOptionCurveLinear animations:^{
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_left);
                make.top.equalTo(self.view).offset(y);
            }];
            
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
