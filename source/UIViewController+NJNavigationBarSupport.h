//
//  UIViewController+NJNavigationBarSupport.h
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJNavigationBar.h"

@interface UIViewController (NJNavigationBarSupport)

//使用这个获取真正的bar
@property (nonatomic, readonly) NJNavigationBar *nj_currentBar;

@end
