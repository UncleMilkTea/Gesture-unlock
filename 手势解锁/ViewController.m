//
//  ViewController.m
//  手势解锁
//
//  Created by 侯玉昆 on 16/1/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "ViewController.h"
#import "HYKLocker.h"
#import "HYKQQmian.h"
#import "HYKsegue.h"

@interface ViewController ()<HYKLockerDelegate>

@property (weak, nonatomic) IBOutlet HYKLocker *locker;

@property(assign,nonatomic) BOOL judage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //平铺桌面
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    self.locker.delegate = self;
    
}

- (BOOL)HYKLocker:(HYKLocker *)locker didFinishPassWord:(NSString *)passWord {
    
    _judage = [passWord isEqualToString:@"64231508"] ? YES : NO;
    
    HYKQQmian *qqVc = [[HYKQQmian alloc]init];
    
    HYKsegue *segue = [[HYKsegue alloc]initWithIdentifier:nil source:self destination:qqVc];
    
    [self prepareForSegue:segue sender:nil];
    
    return _judage;

    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {


   
        
        HYKQQmian *qqVc = [[HYKQQmian alloc]init];
        
         qqVc = segue.destinationViewController;



}

@end
