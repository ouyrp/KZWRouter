//
//  KZWDebugViewController.m
//  KZWfinancial
//
//  Created by ouy on 2017/3/8.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWDebugViewController.h"
#import <KZWUtils/KZWUtils.h>

@interface KZWDebugViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;

@end

@implementation KZWDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换服务器环境";
    [self.view addSubview:self.table];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UITableView *) table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换服务器环境" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *beta = [UIAlertAction actionWithTitle:@"beta" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KZWEnvironmentManager setEnvironment:KZWEnvBeta];
        [[NSUserDefaults standardUserDefaults] setObject:@(KZWEnvBeta) forKey:@"LPDB_ENV"];
        cell.textLabel.text = [NSString stringWithFormat:@"切换环境(%@)",[self envString]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *alpha = [UIAlertAction actionWithTitle:@"alpha" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KZWEnvironmentManager setEnvironment:KZWEnvAlpha];
        [[NSUserDefaults standardUserDefaults] setObject:@(KZWEnvAlpha) forKey:@"LPDB_ENV"];
        cell.textLabel.text = [NSString stringWithFormat:@"切换环境(%@)",[self envString]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *pro = [UIAlertAction actionWithTitle:@"Production" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KZWEnvironmentManager setEnvironment:KZWEnvProduction];
        [[NSUserDefaults standardUserDefaults] setObject:@(KZWEnvProduction) forKey:@"LPDB_ENV"];
        cell.textLabel.text = [NSString stringWithFormat:@"切换环境(%@)",[self envString]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:beta];
    [alert addAction:alpha];
    [alert addAction:pro];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"切换环境(%@)",[self envString]];
    }
    return cell;
}

- (NSString *)envString {
    switch ([KZWEnvironmentManager environment]) {
        case KZWEnvBeta:
            return  @"beta";
        case KZWEnvAlpha:
            return @"alpha";
        case KZWEnvProduction:
            return @"Production";
        default:
            return  @"unknow";
    }
}

@end
