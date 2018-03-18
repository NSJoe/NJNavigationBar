//
//  NJNavigationBar.h
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NJNavigationBar : UINavigationBar

@property (nonatomic, readonly) UIImageView *backgroundView;

//设置默认背景色，若没有特别设置，一个VC新显示后均显示为这个颜色
@property (nonatomic) UIColor *preferredBarColor;

@end
