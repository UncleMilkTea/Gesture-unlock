//
//  HYKLocker.m
//  手势解锁
//
//  Created by 侯玉昆 on 16/1/6.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKLocker.h"
#define HYKLineColor [UIColor colorWithRed:0.0 green:170/255.0 blue:255/255.0 alpha:0.5]

@interface HYKLocker ()

@property (strong,nonatomic) UIColor *lineColor;

@property (nonatomic,strong) NSMutableArray *buttonArrray;

@property(strong,nonatomic) NSMutableArray *highlightedArray;

@property(assign,nonatomic) CGPoint line;

@end


@implementation HYKLocker

#pragma mark 开是触屏

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self juadeClick:[touches.anyObject locationInView:self]];
    

}

#pragma mark 移动触屏
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self juadeClick:[touches.anyObject locationInView:self]];
    
    _line = [touches.anyObject locationInView:self];
    
    //移动过程中一直重绘
    [self setNeedsDisplay];


}

#pragma mark 手指离开屏幕

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    NSMutableString *str = [NSMutableString string];
    
    _line = [[self.highlightedArray lastObject] center];//手指离开屏幕的时候将触摸点设置为最后一个按钮的中心点
    
    for (UIButton *btn in self.highlightedArray) {
        
        [str appendFormat:@"%@",@(btn.tag)];
    }

    BOOL isOk = NO;
    
    NSLog(@"%@",str);

    if ([self.delegate respondsToSelector:@selector(HYKLocker:didFinishPassWord:)]) {
        
        
      isOk = [self.delegate HYKLocker:self didFinishPassWord:str];
        
    }
    
    if (isOk == YES) {
        for (UIButton *btn in self.highlightedArray) {
            
            btn.highlighted = NO;
        }
        
        [self.highlightedArray removeAllObjects];
        
        [self setNeedsDisplay];
        
        
        
    }else {
    
        self.userInteractionEnabled = NO;
        
        for (UIButton *btn in self.highlightedArray) {
            
            btn.enabled = NO;
            
            btn.highlighted = NO;
            
        }

        _lineColor = [UIColor redColor];
    
        [self setNeedsDisplay];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (UIButton *btn in self.highlightedArray) {
                
                btn.enabled = YES;
                
            }
            
            self.userInteractionEnabled = YES;
            
            [self.highlightedArray removeAllObjects];
            
            [self setNeedsDisplay];
            
            _lineColor = HYKLineColor;
            
        });
        
        
    }

}


#pragma mark 判断点在没在按钮身上方法

- (void)juadeClick:(CGPoint)location {
    
    for (UIButton *btn in self.buttonArrray) {//遍历数组判断这个触摸的点在没在按钮上
        
       //判断的时候一定要判断按钮状态否则一直添加一个按钮
        if (CGRectContainsPoint(btn.frame, location) && btn.highlighted == NO) {
            
            btn.highlighted = YES;
        
            [self.highlightedArray addObject:btn];
            
        }
    }
}

#pragma mark 重绘操作

- (void)drawRect:(CGRect)rect {

    if (self.highlightedArray.count == 0) {
        
        return;
        
    }else {
    
    UIBezierPath *path = [UIBezierPath bezierPath];//创建路径对象
    
    for (int i=0 ; i<self.highlightedArray.count; i++) {
        
        UIButton *btn = self.highlightedArray[i];//获取按钮
    
        i == 0 ? [path moveToPoint:btn.center] : [path addLineToPoint:btn.center];
        
        
    }
    
    [self.lineColor setStroke];
    
    path.lineWidth = 15;
    
    path.lineJoinStyle = kCGLineJoinRound;
        
    [path addLineToPoint:_line];
    
    [path stroke];
        
    }
}

#pragma mark 在awakeFromNib只添加控件

- (void)awakeFromNib {
    
    for (int i=0; i<9; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag = i;
        
        button.userInteractionEnabled = NO;
        
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
        
        [self addSubview:button];
        
        [self.buttonArrray addObject:button];
    }

}
#pragma mark 在layoutSubviews只设置控件的Frame

- (void)layoutSubviews {

    [super layoutSubviews];
    
    NSInteger row = 3;
    CGFloat btnW = 74;
    CGFloat btnH = btnW;
    CGFloat margin = (self.bounds.size.width - 3*btnW) *.5;
    
    
    for (int i=0; i< self.buttonArrray.count; i++) {
        
        UIButton *btn = self.buttonArrray[i];
        
        CGFloat btnX = (i%row)*(margin + btnW);
        
        CGFloat btnY = (i/row)*(margin + btnH);
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }

}

#pragma mark 数组的懒加载

- (NSMutableArray *)buttonArrray {
    
    if (_buttonArrray == nil) {
        
        _buttonArrray = [NSMutableArray array];
    }
    return _buttonArrray;
}

- (NSMutableArray *)highlightedArray {

    if (_highlightedArray == nil) {
        
        _highlightedArray = [NSMutableArray array];
        
    }
    return _highlightedArray;
}

- (UIColor *)lineColor {

    if (_lineColor == nil) {
        
        _lineColor = HYKLineColor;
    }
    return _lineColor;

}

@end
