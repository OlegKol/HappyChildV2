//
//  TAddCamWiFi5GUnsupViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 20.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamWiFi5GUnsupViewController.h"
#import <WebKit/WebKit.h>
#import "IPDHelper.h"

@interface TAddCamWiFi5GUnsupViewController () <WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation TAddCamWiFi5GUnsupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.websiteDataStore = WKWebsiteDataStore.nonPersistentDataStore;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view insertSubview:self.webView atIndex:0];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.webView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.webView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self loadPage];
}

- (void)loadPage{
    // TODO: открыть веб-урл где описано что 5г+ не поддерживаетсся камерой CamUnsupported5GURLString
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:CamUnsupported5GURLString]]];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    [self.activity startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.activity stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [self.activity stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self.activity stopAnimating];
    __weak typeof(self) wself = self;
    [IPDHelper showError:error withCancelAndRetry:^{
        __strong typeof(wself) sself = wself;if (!sself) return;
        [sself loadPage];
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)needRotate{
    return YES;
}

@end
