//
//  KZWViewController.m
//  KZWRouter
//
//  Created by ouyrp on 12/13/2018.
//  Copyright (c) 2018 ouyrp. All rights reserved.
//

#import "KZWExampleViewController.h"
#import <KZWRouter/KZWRouter.h>
#import <KZWWebViewController_Category/KZWRouter+KZWWebViewController.h>

@interface KZWExampleViewController ()

@end

@implementation KZWExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"打开网页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 200, 50);
    button.center = CGPointMake(self.view.center.x, self.view.center.y/2);
    [button addTarget:self action:@selector(webAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *blockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blockButton setTitle:@"打开网页带回调" forState:UIControlStateNormal];
    [blockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    blockButton.frame = CGRectMake(0, 0, 200, 50);
    blockButton.center = CGPointMake(self.view.center.x, self.view.center.y*3/4);
    [blockButton addTarget:self action:@selector(webBlock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blockButton];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)webAction {
    [[KZWRouter sharedRouter] open:@"KZWRouter_KZWWebViewController://KZWWebViewController?urlString=https%3a%2f%2fwww.zhihu.com%2f"];
}

- (void)webBlock {
    UIViewController *controller = [[KZWRouter sharedRouter] kzw_KZWWebViewController:@"https%3a%2f%2fwww.zhihu.com%2f" callBackHandle:^(NSString *result) {
        NSLog(@"result:%@", result);
    }];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
