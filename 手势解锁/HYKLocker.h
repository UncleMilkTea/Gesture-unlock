//
//  HYKLocker.h
//  手势解锁
//
//  Created by 侯玉昆 on 16/1/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYKLocker;

@protocol HYKLockerDelegate <NSObject>

@optional

- (BOOL)HYKLocker:(HYKLocker *)locker didFinishPassWord:(NSString *)passWord;

@end


@interface HYKLocker : UIView



@property(strong,nonatomic) id<HYKLockerDelegate> delegate;


@end
