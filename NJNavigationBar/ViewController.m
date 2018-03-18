//
//  ViewController.m
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/11.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationItem+NJNavigationBarSupport.h"
#import "UIViewController+NJNavigationBarSupport.h"
#import "NJNavigationBar.h"
#import "SearchViewController.h"

@interface ViewController ()

-(instancetype)initWithStyle:(NJNavigationBarStyle)style color:(UIColor *)cplor;
@property (weak, nonatomic) IBOutlet UIView *colorIndicatorView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *styleSegment;

@property (nonatomic) UISearchController *searchController;

@end

@implementation ViewController

-(instancetype)initWithStyle:(NJNavigationBarStyle)style color:(UIColor *)color{
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"viewController"];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationItem.nj_barStyle = style;
    self.navigationItem.nj_barColor = color;
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =[super initWithCoder:aDecoder]){
//        self.navigationItem.nj_barStyle = NJNavigationBarStyleSingle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"标题:%@",@(self.navigationController.viewControllers.count)];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)push:(id)sender {
    ViewController *vc = [[ViewController alloc] initWithStyle:self.styleSegment.selectedSegmentIndex color:self.colorIndicatorView.backgroundColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)colorSelect:(UIButton *)btn {
    self.colorIndicatorView.backgroundColor = btn.backgroundColor;
}
- (IBAction)clearColor:(id)sender {
    self.colorIndicatorView.backgroundColor = [UIColor clearColor];
}
- (IBAction)noSetting:(id)sender {
    self.colorIndicatorView.backgroundColor = nil;
    [self push:nil];
}
- (IBAction)setToDefault:(id)sender {
    NJNavigationBar *sharedBar = (NJNavigationBar *)self.navigationController.navigationBar;
    sharedBar.preferredBarColor = self.colorIndicatorView.backgroundColor;
    
    //如果当前是single style， 当前bar颜色需要用以下代码
    self.nj_currentBar.preferredBarColor = self.colorIndicatorView.backgroundColor;
}
- (IBAction)go2Search:(id)sender {
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.navigationItem.nj_barColor = self.colorIndicatorView.backgroundColor;
    //不支持 在single模式下使用 searchBar
    vc.navigationItem.nj_barStyle = NJNavigationBarStyleDefault;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
