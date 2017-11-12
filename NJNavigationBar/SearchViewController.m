//
//  SearchViewController.m
//  NJNavigationBar
//
//  Created by Joe's MacBook Pro on 2017/11/12.
//  Copyright © 2017年 joe. All rights reserved.
//

#import "SearchViewController.h"
#import "UINavigationItem+NJNavigationBarSupport.h"
#import "NJNavigationBar.h"

@interface ResultViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@end

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *navi = [[UINavigationController alloc] init];
    navi.viewControllers = @[[ResultViewController new]];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:navi];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    
    return cell;
}

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"push 到 default";
    } else {
        cell.textLabel.text = @"push 到 single";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"viewController"];
    if (indexPath.row == 0) {
        vc.navigationItem.nj_barStyle = NJNavigationBarStyleDefault;
    } else {
        vc.navigationItem.nj_barStyle = NJNavigationBarStyleSingle;
    }
    UINavigationController *navi = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
