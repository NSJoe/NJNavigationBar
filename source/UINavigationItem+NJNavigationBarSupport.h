//
//  UINavigationItem+NJNavigationBarSupport.h
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NJNavigationBarStyle) {
    NJNavigationBarStyleDefault,    //默认的，push pop 时的动画效果和系统默认一致，背景色会根据设置的barColor渐变
    NJNavigationBarStyleSingle      //单独的，每个vc创建单独的bar，如果有在界面显示隐藏导航栏的功能，请使用default
};

@interface UINavigationItem (NJNavigationBarSupport)

@property (nonatomic) UIColor *nj_barColor;
@property (nonatomic) NJNavigationBarStyle nj_barStyle;

@end
