//
//  KZWDebugModeViewController.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/7/10.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWDebugModeViewController.h"
#import <KZWUtils/KZWUtils.h>
#import <WebKit/WebKit.h>
#import "KZWToast.h"

@interface KZWDebugModeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation KZWDebugModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调试模式";
    self.titleArray = @[@"访问URL", @"访问标的", @"快速访问WAP页", @"查看日志", @"清楚缓存", @"网速限制"];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KZW_StatusBarAndNavigationBarHeight) style:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine automatic:NO];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"debugmodecell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            view.backgroundColor = [UIColor colorWithHexString:BGColorf5f5f5];
            view;
        });
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"debugmodecell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:FontColor333333];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self showAlert:indexPath.row];
            break;
        case 1:
            [self showAlert:indexPath.row];
            break;
        case 4:
            [self clearCache];
            break;
        case 5:
            [KZWToast show:@"请前往设置开发者中设置你想要的网速限制"];
            break;
       case 2:
            //加跳转
            break;
        case 3:
            [KZWToast show:@"摇一摇查看"];
            break;
        default:
            break;
    }
    
}

- (void)showAlert:(NSInteger)row {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:(row==0)?@"输入URL":@"输入标的ID" message:nil preferredStyle:1];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = (row==0)?@"请输入URL":@"请输入标的ID";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
        NSLog(@"ok, %@", [[alert textFields] objectAtIndex:0].text);
        if (row == 0) {
            
        }else {
            
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    // 添加行为
    [alert addAction:action2];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record  in records)
                             {
                                 if ( [record.displayName containsString:@"kongzhongjr"])
                                 {
                                     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                               forDataRecords:@[record]
                                                                            completionHandler:^{
                                                                                NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                                [KZWToast show:@"清除成功"];
                                                                            }];
                                 }
                             }
                         }];
    }else {
        NSString *librarypath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cookiesFolderPath = [librarypath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }
}

@end
