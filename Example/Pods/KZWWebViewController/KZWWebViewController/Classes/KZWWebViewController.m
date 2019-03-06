//
//  KZWWebViewController.m
//  KZWfinancial
//
//  Created by ouy on 2017/3/15.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWWebViewController.h"
#import "WKCookieSyncManager.h"
#import "KZWJavaScripInterface.h"
#import "KZWURLCacheUtil.h"
#import "KZWWeakScriptMessageDelegate.h"
#import <KZWUtils/KZWUtils.h>
#import <KZWUI/KZWUI.h>
#import <FMWebViewJavascriptBridge/FMWKWebViewBridge.h>

@interface KZWWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIScrollViewDelegate>

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSString *htmlString;
@property (strong, nonatomic) NSString *baseURL;
@property (strong, nonatomic) KZWJavaScripInterface *JavaScripInterface;
@property(nonatomic, strong) FMWKWebViewBridge *webViewBridge;
@property(nonatomic, strong) WKWebView *webView;
@property (nonatomic) UIBarButtonItem *leftBarButton;
@property (nonatomic) UIBarButtonItem *closeBarButton;
@property (nonatomic, copy) void (^callBack)(NSString *);

@end

@implementation KZWWebViewController

- (instancetype)initWithUrl:(NSString *)urlString {
    return [self initWithUrl:urlString callBackHandle:nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
    if (self = [super init]) {
        self.request = request;
    }
    return self;
}

- (instancetype)initHTMLString:(NSString *)htmlString baseURL:(NSString *)baseURL {
    if (self = [super init]) {
        self.htmlString = htmlString;
        self.baseURL = baseURL;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)urlString callBackHandle:(void (^)(NSString *))callBackHandle {
    if (self = [super init]) {
        self.urlString = urlString;
        _callBack = [callBackHandle copy];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
    [self.view addSubview:self.progressView];
    if (self.urlString.length > 0) {
        [self requestWithUrl];
    }else if (self.htmlString.length > 0) {
        [self requestWithHtml];
    }else {
        [self requestWithRequest];
    }
    
    CGFloat offsetY = 0;
    offsetY = [[KZWURLCacheUtil sharedInstance] getYPositionForURL:self.webView.URL.absoluteString];
    
    if (offsetY) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.webView.scrollView setContentOffset:CGPointMake(0, offsetY) animated:NO];
        } completion:^(BOOL finished) {}];
    }
}

- (void)requestWithRequest {
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:self.request.URL];
    [mutableRequest addValue:[self readCurrentCookie] forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:mutableRequest];
}

- (void)requestWithUrl {
    NSString *fullString = [self fullString:[self.urlString KZW_URLDecodedString]];
    NSURL *url = [NSURL URLWithString:fullString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:[self readCurrentCookie] forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
}

- (void)requestWithHtml {
    [self.webView loadHTMLString:self.htmlString baseURL:[NSURL URLWithString:[self.baseURL KZW_URLDecodedString]]];
}

- (UIBarButtonItem *)leftBarButton {
    if (!_leftBarButton) {
        _leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[self imageWithName:@"ic_bk_back"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 30, 30);
            button;
        })];
    }
    return _leftBarButton;
}

- (UIBarButtonItem *)closeBarButton {
    if (!_closeBarButton) {
        _closeBarButton = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[self imageWithName:@"ic_bk_close"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 30, 30);
            button;
        })];
    }
    return _closeBarButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initWebView {
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource:[NSString stringWithFormat:@"document.cookie = '%@'", [self setCurrentCookie]]
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    [userContentController addScriptMessageHandler:[[KZWWeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"BKJFReload"];
    WKCookieSyncManager *cookiesManager = [WKCookieSyncManager sharedWKCookieSyncManager];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.processPool = cookiesManager.processPool;
    configuration.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KZW_NavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - KZW_NavigationBarHeight) configuration:configuration];
    if (KZW_iPhoneX) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.webViewBridge = [FMWKWebViewBridge wkwebViewBridge:self.webView];
    self.JavaScripInterface = [[KZWJavaScripInterface alloc] init];
    [self.webViewBridge addJavascriptInterface:self.JavaScripInterface withName:@"JavaScripInterface"];
    self.webView.scrollView.bounces = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:self.webView];
}

- (NSString *)readCurrentCookie {
    return @"";
}

- (NSString *)setCurrentCookie {
    return @"";
}

- (void)rightAction:(UIButton *)sender {
    
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, KZW_NavigationBarHeight, SCREEN_WIDTH, 1);
        [_progressView setTrackTintColor:[UIColor clearColor]];
        _progressView.progressTintColor = [UIColor baseColor];
    }
    return _progressView;
}

#pragma mark wkwebdelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];//解析url
    //url截取根据自己业务增加代码
    if ([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"] && [[UIApplication sharedApplication] openURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if([urlString hasPrefix:@"tel"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.callBack) {
        self.callBack(@"sucess");
    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]
        && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:animated];
        if (self.webView.estimatedProgress >= 1.0f) {
            @WeakObj(self)
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 @StrongObj(self)
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 @StrongObj(self)
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.webView.title;
    }else if ([keyPath isEqualToString:@"loading"]) {
        [self setLeftBarButtonItems];
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)setLeftBarButtonItems {
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.leftBarButton, self.closeBarButton];
    }else {
        self.navigationItem.leftBarButtonItems = @[self.leftBarButton];
    }
}

-(void)dismissModalStack {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[KZWWebViewController class]]) {
            [self dismissModalStack];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeAction {
    if ([self.navigationController.viewControllers.firstObject isKindOfClass:[KZWWebViewController class]]) {
        [self dismissModalStack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)fullString:(NSString *)path {
    NSString *domain = nil;
    switch ([KZWEnvironmentManager environment]) {
        case KZWEnvBeta:
            domain = @"xxxxx";
            break;
        case KZWEnvAlpha:
            domain = @"xxxxx";
            break;
        case KZWEnvProduction:
            domain = @"xxxxx";
            break;
        default:
            domain = @"xxxxx";
            break;
    }
    if ([path containsString:@"http"]) {
        return path;
    }else {
        return [domain stringByAppendingString:path];
    }
}

- (UIImage *)imageWithName:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                            stringByAppendingPathComponent:@"/KZWWebViewController.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:imageName
                                inBundle:resource_bundle
           compatibleWithTraitCollection:nil];
    return image;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY =  self.webView.scrollView.contentOffset.y;
    [[KZWURLCacheUtil sharedInstance] insertURL:self.webView.URL.absoluteString
                                       yPosition:offsetY];
}

- (void)dealloc {
    [self.webView stopLoading];
    self.webView.UIDelegate = nil;
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(loading))];
    self.webView = nil;
}

@end
