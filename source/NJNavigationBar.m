//
//  NJNavigationBar.m
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "NJNavigationBar.h"

@interface NJNavigationBar ()

@property (nonatomic, readwrite) UIImageView *backgroundView;

@end

@implementation NJNavigationBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self defaultConfig];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultConfig];
    }
    return self;
}

-(void)defaultConfig{
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    self.backgroundView = [UIImageView new];
    [self insertSubview:self.backgroundView atIndex:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = [self defaultBackgroundFrame];
    self.backgroundView.frame = rect;
    [self sendSubviewToBack:self.backgroundView];
}

-(void)setPreferredBarColor:(UIColor *)preferredBarColor{
    _preferredBarColor = preferredBarColor;
    self.backgroundView.backgroundColor = preferredBarColor;
}

-(CGRect)defaultBackgroundFrame{
//    CGFloat offset = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat offset = 44.0;//横竖屏切换的时候上边的值获取可能错误，监听statusFrame通知也拿不到正确的值，先这么搞把
    CGRect rect = self.bounds;
    rect.origin.y -= offset;
    rect.size.height += offset;
    return rect;
}

@end
