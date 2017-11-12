//
//  UIViewController+NJNavigationBarSupport.m
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "UIViewController+NJNavigationBarSupport.h"
#import "NJNavigationBar.h"
#import "UINavigationItem+NJNavigationBarSupport.h"
#import <objc/runtime.h>

static const char *NJNavigationBarKey = "NJNavigationBarKey";
static const char *NJNavigationDelegateKey = "NJNavigationDelegateKey";

static inline void nj_exchangeViewControllerImp(SEL old, SEL new) {
    Method origin =  class_getInstanceMethod([UIViewController class], old);
    Method replace = class_getInstanceMethod([UIViewController class], new);
    method_exchangeImplementations(origin, replace);
}

@interface UIViewController()<UINavigationBarDelegate>

@end

@implementation UIViewController (NJNavigationBarSupport)

+(void)load{
    nj_exchangeViewControllerImp(@selector(setTitle:), @selector(nj_setTitle:));
    nj_exchangeViewControllerImp(@selector(viewDidLoad), @selector(nj_viewDidLoad));
    nj_exchangeViewControllerImp(@selector(viewDidUnload), @selector(nj_viewDidUnload));
    nj_exchangeViewControllerImp(@selector(viewDidLayoutSubviews), @selector(nj_viewDidLayoutSubviews));
    nj_exchangeViewControllerImp(@selector(viewWillAppear:), @selector(nj_viewWillAppear:));
    nj_exchangeViewControllerImp(@selector(viewWillDisappear:), @selector(nj_viewWillDisappear:));
}

-(void)nj_viewDidLoad{
    [self nj_viewDidLoad];
    [self nj_setupBarIfNeed];
}

-(void)nj_viewDidUnload{
    [self nj_viewDidUnload];
    objc_setAssociatedObject(self, NJNavigationBarKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)nj_viewWillAppear:(BOOL)animated{
    [self nj_viewWillAppear:animated];
    [self nj_retreivePopDelegate];
    if ([self nj_checkIsNaviCustomized]) {
        [self nj_alongsideTrasition:^{
            self.nj_standardBar.backgroundView.backgroundColor = self.navigationItem.nj_barColor ?: self.nj_standardBar.preferredBarColor;
        }];
    } else if (self.navigationItem.nj_barStyle == NJNavigationBarStyleSingle) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if (self.navigationController.viewControllers.count > 1) {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id)self.navigationController;
        }
    }
}

-(void)nj_viewWillDisappear:(BOOL)animated{
    [self nj_viewWillDisappear:animated];
    if (self.navigationItem.nj_barStyle == NJNavigationBarStyleSingle) {
        if ([self isMovingFromParentViewController]) {
            BOOL fromDefaultStyle = self.nj_previousItemOnPop.nj_barStyle == NJNavigationBarStyleDefault;
            if (fromDefaultStyle) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
        } else {
            BOOL toDefaultStyle = self.nj_nextItemOnPush.nj_barStyle == NJNavigationBarStyleDefault;
            if (toDefaultStyle) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
            }
        }
    }
}

-(void)nj_viewDidLayoutSubviews{
    [self nj_viewDidLayoutSubviews];
    NJNavigationBar *bar = objc_getAssociatedObject(self, NJNavigationBarKey);
    bar.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height, self.view.frame.size.width, 44);
    [self.view bringSubviewToFront:bar];
}

-(void)nj_retreivePopDelegate{
    //为了处理一个bug：当delegate设置过给vc之后，再到第一页，触发pop手势，再push会有bug
    if (!self.navigationController) {
        return;
    }
    id delegate = objc_getAssociatedObject(self.navigationController, NJNavigationDelegateKey);
    if (!delegate) {
        delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        objc_setAssociatedObject(self.navigationController, NJNavigationDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = delegate;
}

-(void)nj_setupBarIfNeed{
    if (objc_getAssociatedObject(self, NJNavigationBarKey)) {
        return;
    }
    if (self.navigationItem.nj_barStyle == NJNavigationBarStyleSingle) {
        NJNavigationBar *bar = [[NJNavigationBar alloc] init];
        bar.backgroundView.backgroundColor = self.navigationItem.nj_barColor ?: self.nj_standardBar.preferredBarColor;
        bar.delegate = self;
        bar.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height, self.view.frame.size.width, 44);
        if (self.nj_previousItemOnPush) {
            UINavigationItem *item = [UINavigationItem new];
            item.title = self.nj_previousItemOnPush.title;
            [bar pushNavigationItem:item animated:NO];
        }
        UINavigationItem *foregroundItem = [UINavigationItem new];
        foregroundItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
        foregroundItem.title = self.navigationItem.title ?: self.title;
        foregroundItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
        [bar pushNavigationItem:foregroundItem animated:NO];
        [self.view addSubview:bar];
        objc_setAssociatedObject(self, NJNavigationBarKey, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(UINavigationItem *)nj_previousItemOnPush{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index == 0 || index == NSNotFound) {
        NSLog(@"找不到上一个Item");
        return nil;
    }
    return [self.navigationController.viewControllers objectAtIndex:index - 1].navigationItem;
}

-(UINavigationItem *)nj_previousItemOnPop{
    return self.navigationController.viewControllers.lastObject.navigationItem;
}

-(UINavigationItem *)nj_nextItemOnPush{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index == self.navigationController.viewControllers.count - 1 || index == NSNotFound) {
        NSLog(@"找不到下一个Item");
        return nil;
    }
    return [self.navigationController.viewControllers objectAtIndex:index + 1].navigationItem;
}

-(void)nj_alongsideTrasition:(void (^)(void))animate{
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.navigationController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (animate) animate();
    } completion:NULL];
}

-(NJNavigationBar *)nj_standardBar{
    return (NJNavigationBar *)self.navigationController.navigationBar;
}

-(BOOL)nj_barColorIsEqual{
    return [self.nj_standardBar.backgroundView.backgroundColor isEqual:self.navigationItem.nj_barColor];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

-(void)nj_setTitle:(NSString *)title{
    [self nj_setTitle:title];
    NJNavigationBar *bar = objc_getAssociatedObject(self, NJNavigationBarKey);
    bar.topItem.title = title;
}

-(NJNavigationBar *)nj_currentBar{
    if (self.navigationItem.nj_barStyle == NJNavigationBarStyleDefault) {
        return [self nj_standardBar];
    } else if (self.navigationItem.nj_barStyle == NJNavigationBarStyleSingle) {
        return objc_getAssociatedObject(self, NJNavigationBarKey);
    }
    return nil;
}

-(BOOL)nj_checkIsNaviCustomized{
    return self.navigationItem.nj_barStyle == NJNavigationBarStyleDefault && [self.navigationController.navigationBar isKindOfClass:[NJNavigationBar class]];
}

@end
