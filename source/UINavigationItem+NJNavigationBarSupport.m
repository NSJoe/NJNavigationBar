//
//  UINavigationItem+NJNavigationBarSupport.m
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "UINavigationItem+NJNavigationBarSupport.h"
#import <objc/runtime.h>

static const char *NJNavigationItemAssociateKey = "NJNavigationItemAssociateKey";

static inline void nj_exchangeViewControllerImp(SEL old, SEL new) {
    Method origin =  class_getInstanceMethod([UINavigationItem class], old);
    Method replace = class_getInstanceMethod([UINavigationItem class], new);
    method_exchangeImplementations(origin, replace);
}

@implementation UINavigationItem (NJNavigationBarSupport)

+(void)load{
    nj_exchangeViewControllerImp(@selector(setLeftBarButtonItem:), @selector(nj_setLeftBarButtonItem:));
    nj_exchangeViewControllerImp(@selector(setLeftBarButtonItems:), @selector(nj_setLeftBarButtonItems:));
    nj_exchangeViewControllerImp(@selector(setLeftBarButtonItem:animated:), @selector(nj_setLeftBarButtonItem:animated:));
    nj_exchangeViewControllerImp(@selector(setLeftBarButtonItems:animated:), @selector(nj_setLeftBarButtonItems:animated:));
    nj_exchangeViewControllerImp(@selector(setRightBarButtonItem:), @selector(nj_setRightBarButtonItem:));
    nj_exchangeViewControllerImp(@selector(setRightBarButtonItems:), @selector(nj_setRightBarButtonItems:));
    nj_exchangeViewControllerImp(@selector(setRightBarButtonItem:animated:), @selector(nj_setRightBarButtonItem:animated:));
    nj_exchangeViewControllerImp(@selector(setRightBarButtonItems:animated:), @selector(nj_setRightBarButtonItems:animated:));
    nj_exchangeViewControllerImp(@selector(setTitle:), @selector(nj_setTitle:));
    nj_exchangeViewControllerImp(@selector(setTitleView:), @selector(nj_setTitleView:));
    nj_exchangeViewControllerImp(@selector(setPrompt:), @selector(nj_setPrompt:));
    nj_exchangeViewControllerImp(@selector(setHidesBackButton:), @selector(nj_setHidesBackButton:));
    nj_exchangeViewControllerImp(@selector(setHidesBackButton:animated:), @selector(nj_setHidesBackButton:animated:));
}

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

-(void)setNj_bind:(UINavigationItem *)item{
    objc_setAssociatedObject(self, NJNavigationItemAssociateKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UINavigationItem *)nj_bind{
    return objc_getAssociatedObject(self, NJNavigationItemAssociateKey);
}

//hook

-(void)nj_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setLeftBarButtonItem:leftBarButtonItem];
}

-(void)nj_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setLeftBarButtonItems:leftBarButtonItems];
}

-(void)nj_setLeftBarButtonItem:(UIBarButtonItem *)barItem animated:(BOOL)animated{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setLeftBarButtonItem:barItem animated:animated];
}

-(void)nj_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setLeftBarButtonItems:items animated:animated];
}

-(void)nj_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setRightBarButtonItem:rightBarButtonItem];
}

-(void)nj_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setRightBarButtonItems:rightBarButtonItems];
}

-(void)nj_setRightBarButtonItem:(UIBarButtonItem *)barItem animated:(BOOL)animated{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setRightBarButtonItem:barItem animated:animated];
}

-(void)nj_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setRightBarButtonItems:items animated:animated];
}

-(void)nj_setTitle:(NSString *)title{
    [self nj_setTitle:title];
    [self.nj_bind nj_setTitle:title];
}

-(void)nj_setTitleView:(UIView *)titleView{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setTitleView:titleView];
}

-(void)nj_setPrompt:(NSString *)prompt{
    [self nj_setPrompt:prompt];
    [self.nj_bind nj_setPrompt:prompt];
}

-(void)nj_setHidesBackButton:(BOOL)hidesBackButton{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setHidesBackButton:hidesBackButton];
}

-(void)nj_setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated{
    UINavigationItem *item = self.nj_bind ?: self;
    [item nj_setHidesBackButton:hidesBackButton animated:animated];
}

@end

