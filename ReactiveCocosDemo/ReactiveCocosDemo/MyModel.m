//
//  MyModel.m
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

/** 模拟网络请求 */
- (RACSignal *)reqWithSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"thread sleep 3s ~~~");
//        [NSThread sleepForTimeInterval:3];
        [subscriber sendNext:@"result"];
        [subscriber sendCompleted];
        if (0) {
            [subscriber sendError:nil];
        }
        return nil;
    }];
}

@end
