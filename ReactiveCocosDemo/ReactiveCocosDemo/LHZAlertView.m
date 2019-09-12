//
//  LHZAlertView.m
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LHZAlertView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#define RGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface LHZAlertView()

@property (nonatomic,strong) UIView * mainView;
@property (nonatomic,strong) UILabel * lbTitle;
@property (nonatomic,strong) UILabel * lbContent;
@property (nonatomic,strong) UIView * btnBgView;
@property (nonatomic,strong) UIButton * btncancel;
@property (nonatomic,strong) NSMutableArray * btnsArray;

@property (nonatomic,strong) NSString * titleText;
@property (nonatomic,strong) NSString * detailText;
@property (nonatomic, copy) NSString * cancelBtnTitle; ///<
@property (nonatomic,strong) NSArray * btnTitlesArray;

@property (nonatomic, copy) LHZAlertViewBtnIndexBlock resultBtnIndexBlock ;

@end

@implementation LHZAlertView

+ (LHZAlertView *)alertViewWithTitle:(NSString *)title detail:(NSString *)detail cancelBtnTitle:(NSString *)cancelTitle otherBtnTitles:(NSArray <NSString *>*)btnTitles {
    LHZAlertView * alertView = [[LHZAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    alertView.titleText = title;
    alertView.detailText = detail;
    alertView.cancelBtnTitle = cancelTitle;
    alertView.btnTitlesArray = btnTitles;
    [alertView createViews];
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(51, 51, 51, 0.5);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 5;
}

#pragma mark - 显示

/** 显示 */
- (void)showAlertInView:(UIView *)showView btnSelectedResultBlock:(LHZAlertViewBtnIndexBlock)block {
    for (UIView * view in showView.subviews) {
        if ([view isKindOfClass:[LHZAlertView class]]) {
            LHZAlertView * alertView = (LHZAlertView *)view;
            [alertView hiddenView];
        }
    }
    
    self.resultBtnIndexBlock = block;
    
    [showView addSubview:self];
    
    [self needsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(0.7);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_greaterThanOrEqualTo(160);
        }];
        [self layoutIfNeeded];
    }];
    
}

/** 隐藏 */
- (void)hiddenView {
    
    [self needsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width).multipliedBy(0.7);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

#pragma mark - create View

- (void)createViews {
    [self addSubview:self.mainView];
    
    [self.mainView addSubview:self.lbTitle];
    [self.mainView addSubview:self.lbContent];
    [self.mainView addSubview:self.btnBgView];
    [self.btnBgView addSubview:self.btncancel];
    
    [self createBtns];
    
    [self addLayout];
}

/** 创建按钮 */
- (void)createBtns {
    
    self.btnsArray = [NSMutableArray new];
    for (NSInteger i = 0; i < self.btnTitlesArray.count; i ++) {
        NSString * btnTitle = self.btnTitlesArray[i];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectZero];
        btn.tag = 101 + i;
        [btn setTitle:btnTitle forState:(UIControlStateNormal)];
        [btn setTitleColor:RGB(51, 51, 51) forState:(UIControlStateNormal)];
        [btn setBackgroundColor:RGB(248, 248, 248)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnBgView addSubview:btn];
        
        @weakify(self);
        [[[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)]
         map:^id(UIButton * nowBtn) {
             return @(nowBtn.tag - 100);
         }]
         subscribeNext:^(NSNumber * index) {
             @strongify(self);
             [self hiddenView];
             if (self.resultBtnIndexBlock) {
                 self.resultBtnIndexBlock(index.integerValue);
             }
        }];
        
        [self.btnsArray addObject:btn];
    }
}

#pragma mark - layout

- (void)addLayout {
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).multipliedBy(0.7);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_bottom);
        make.height.mas_greaterThanOrEqualTo(160);
    }];
    
    
    CGFloat titleTop = self.titleText.length > 0 ? 15 : 0;
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(titleTop);
        make.height.mas_lessThanOrEqualTo(25);
    }];
    
    [self.lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.lbTitle.mas_bottom).offset(15);
    }];
    
    [self.btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.top.equalTo(self.lbContent.mas_bottom).offset(20);
        make.bottom.mas_equalTo(0);
    }];
    
    NSInteger count = self.btnsArray.count + 1;
    if (count == 1) {
        [self.btncancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(1);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(0);
        }];
    }else if (count <= 3) {
        [self.btncancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(1);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(0);
        }];
        
        UIButton * lastBtn = self.btncancel;
        for (NSInteger i = 0; i < self.btnsArray.count; i ++) {
            UIButton * btn = self.btnsArray[i];
            
            
            if (i == self.btnsArray.count - 1) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastBtn.mas_right).offset(1);
                    make.top.equalTo(self.btncancel.mas_top);
                    make.height.equalTo(self.btncancel.mas_height);
                    make.width.equalTo(self.btncancel.mas_width);
                    make.right.mas_equalTo(0);
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastBtn.mas_right).offset(1);
                    make.top.equalTo(self.btncancel.mas_top);
                    make.height.equalTo(self.btncancel.mas_height);
                    make.width.equalTo(self.btncancel.mas_width);
                }];
            }
            lastBtn = btn;
        }
    }else {
        [self.btncancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(1);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(0);
        }];
        
        UIButton * lastBtn = self.btncancel;
        for (NSInteger i = self.btnsArray.count - 1; i >= 0; i --) {
            UIButton * btn = self.btnsArray[i];
            
            if (i == 0) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.bottom.equalTo(lastBtn.mas_top).offset(-1);
                    make.height.equalTo(self.btncancel.mas_height);
                    make.right.mas_equalTo(0);
                    make.top.mas_equalTo(1);
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.bottom.equalTo(lastBtn.mas_top).offset(-1);
                    make.height.equalTo(self.btncancel.mas_height);
                    make.right.mas_equalTo(0);
                }];
            }
            lastBtn = btn;
        }
    }
}

#pragma mark - 懒加载

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW / 2.0, ScreenH / 2.0, 0, 0)];
        _mainView.backgroundColor = RGB(248, 248, 248);
    }
    return _mainView;
}

- (UIView *)btnBgView {
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _btnBgView.backgroundColor = RGB(153, 153, 153);
    }
    return _btnBgView;
}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTitle.textColor =  RGB(51, 51, 51);
        _lbTitle.font = [UIFont systemFontOfSize:17];
        _lbTitle.text = self.titleText;
        _lbTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lbTitle;
}

- (UILabel *)lbContent {
    if (!_lbContent) {
        _lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbContent.textColor =  RGB(51, 51, 51);
        _lbContent.font = [UIFont systemFontOfSize:15];
        _lbContent.text = self.detailText;
        _lbContent.textAlignment = NSTextAlignmentCenter;
        _lbContent.numberOfLines = 0;
    }
    return _lbContent;
}

- (UIButton *)btncancel {
    if (!_btncancel) {
        _btncancel = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btncancel setTitle:self.cancelBtnTitle.length > 0 ? self.cancelBtnTitle : @"取消" forState:(UIControlStateNormal)];
        [_btncancel setTitleColor:RGB(102, 102, 102) forState:(UIControlStateNormal)];
        [_btncancel setBackgroundColor:RGB(248, 248, 248)];
        _btncancel.tag = 100;
        _btncancel.titleLabel.font = [UIFont systemFontOfSize:15];
        @weakify(self);
        [[[_btncancel rac_signalForControlEvents:(UIControlEventTouchUpInside)]
          map:^id(UIButton * btn) {
              return @(btn.tag - 100);
          }]
         subscribeNext:^(NSNumber * index) {
             @strongify(self);
             [self hiddenView];
             if (self.resultBtnIndexBlock) {
                 self.resultBtnIndexBlock(index.integerValue);
             }
         }];
    }
    return _btncancel;
}


@end
