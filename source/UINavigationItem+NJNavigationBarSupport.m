//
//  UINavigationItem+NJNavigationBarSupport.m
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "UINavigationItem+NJNavigationBarSupport.h"
#import <objc/runtime.h>

@implementation UINavigationItem (NJNavigationBarSupport)

-(UIColor *)nj_barColor{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setNj_barColor:(UIColor *)nj_barColor{
    objc_setAssociatedObject(self, @selector(nj_barColor), nj_barColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NJNavigationBarStyle)nj_barStyle{
    NSNumber *style = objc_getAssociatedObject(self, _cmd);
    return style.integerValue;
}

-(void)setNj_barStyle:(NJNavigationBarStyle)nj_barStyle{
    objc_setAssociatedObject(self, @selector(nj_barStyle), @(nj_barStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
