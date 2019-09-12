//
//  ViewController.m
//  ReactiveCocosDemo
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MyModel.h"

#import "LHZAlertView.h"
#import "LHZAlertInputView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    [btn setTitle:@"点击" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    
    //添加点击事件
    @weakify(self);
    //创建signal
    RACSignal * signal = [btn rac_signalForControlEvents:(UIControlEventTouchUpInside)];
    //订阅信号
    
//    [signal doNext:^(id x) {
//        NSLog(@"next 11111");
//        [NSThread sleepForTimeInterval:3];
//    }]
      [[[signal flattenMap:^RACStream *(id value) {
        return [[[MyModel alloc] reqWithSignal] catch:^RACSignal *(NSError *error) {
            
            NSLog(@"aaaa");
            return [RACSignal empty];
        }];
    }]
     flattenMap:^RACStream *(id value) {
         return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
             @strongify(self);
            LHZAlertInputView * inputView = [LHZAlertInputView alertInputViewWithTitle:@"群名称" placeholder:@"2~5个字符" cancelBtnTitle:@"取消" sureBtnTitles:@"确定"];
             [inputView showInView:self.view textSiftBlock:^NSString * _Nullable(NSString * _Nonnull str) {
                 if (str.length < 2 || str.length > 5) {
                     return @"请输入2~5个字符";
                 }
                 return @"";
             } resultBlock:^(NSString * _Nonnull str) {
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
             }];
             return nil;
         }];
     }]
     subscribeNext:^(id x) {
         @strongify(self);
         LHZAlertView * alertView = [LHZAlertView alertViewWithTitle:@"" detail:@"adfasdfadfad" cancelBtnTitle:@"取消" otherBtnTitles:@[]];
         [alertView showAlertInView:self.view btnSelectedResultBlock:^(NSInteger btnIndex) {
             NSLog(@"btn index : %ld", btnIndex);
         }];
         NSLog(@"ssss");
     }];
    
    
//    [signal  subscribeNext:^(id x) {
//        NSLog(@"点击。。。。。。。");
//    }];
    
    
//    RACSubject * subObject = [RACSubject subject];
    
    
}


@end
