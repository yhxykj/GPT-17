//
//  TWPrivacyViewController.m
//  TaoWu
//
//  Created by JJK on 2023/12/19.
//

#import "TWPrivacyViewController.h"
#import <WebKit/WebKit.h>

@interface TWPrivacyViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *tw_wkwebView;
@property (strong, nonatomic) UIProgressView *tw_progressView; /// 进度条

@end

@implementation TWPrivacyViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [self.tw_wkwebView removeObserver:self forKeyPath:@"estimatedProgress"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tw_wkwebView.navigationDelegate = self;
    self.tw_wkwebView.backgroundColor = UIColor.clearColor;
    
    if ([self.web_type isEqualToString:@"隐私协议"]) {
        self.navigationItem.title = @"隐私协议";
        [self.tw_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cb3i458lt6.feishu.cn/docx/XL7adCdDloiuUax0SRqchbzcnDe"]]];
    }
    else if ([self.web_type isEqualToString:@"用户协议"]) {
        self.navigationItem.title = @"用户协议";
        [self.tw_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cb3i458lt6.feishu.cn/docx/FP01dfdtAorPe4xMygicgY7Vnmf"]]];
    }
    else {
        self.navigationItem.title = @"连续包月服务";
        [self.tw_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cb3i458lt6.feishu.cn/docx/KPDmd7VX0ogePdxIBRCcg0kInAd"]]];
    }
    
    self.tw_progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, TWStatusBarHeight() + 42, CGRectGetWidth(self.view.frame), 2)];
    self.tw_progressView.progressTintColor = UIColorFromRGB(0x28D270);
    self.tw_progressView.trackTintColor = UIColorFromRGB(0xe1e1e1);
    [self.view addSubview:self.tw_progressView];
    
    
    [self.tw_wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.tw_wkwebView) {
        [self.tw_progressView setAlpha:1.0f];
        [self.tw_progressView setProgress:self.tw_wkwebView.estimatedProgress animated:YES];
        if(self.tw_wkwebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.tw_progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.tw_progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [SVProgressHUD dismiss];
}


@end
