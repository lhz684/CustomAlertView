//
//  MyModel.h
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyModel : NSObject

/** 模拟网络请求 */
- (RACSignal *)reqWithSignal;

@end

NS_ASSUME_NONNULL_END
