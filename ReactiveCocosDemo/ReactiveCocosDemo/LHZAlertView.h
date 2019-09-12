//
//  LHZAlertView.h
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LHZAlertViewBtnIndexBlock)(NSInteger btnIndex);

@interface LHZAlertView : UIView

#pragma mark - 显示
+ (LHZAlertView *)alertViewWithTitle:(NSString *)title detail:(NSString *)detail cancelBtnTitle:(NSString *)cancelTitle otherBtnTitles:(NSArray <NSString *>*)btnTitles;
/** 显示 */
- (void)showAlertInView:(UIView *)showView btnSelectedResultBlock:(LHZAlertViewBtnIndexBlock)block;

@end

NS_ASSUME_NONNULL_END

