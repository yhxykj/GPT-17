//
//  TTSplashAd.mm
//
//  Created by Jaymz on 2020/7/24.
//

#import <Foundation/Foundation.h>
#import "TTSplashAd.h"
#import <BUAdSDK/BUSplashAd.h>
#import "ADConfig.h"
#import "AppDelegate.h"


@interface TTSplashAd()<BUSplashAdDelegate, BUSplashCardDelegate, BUSplashZoomOutDelegate>
@property (nonatomic, strong) BUSplashAd *splashAd;
@property (nonatomic, assign) CFTimeInterval startTime;

@end

static TTSplashAd* m_instance;

@implementation TTSplashAd

+ (instancetype)shareInstance {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        m_instance = [[self alloc] init];
    });
    return m_instance;
}

-(void) ShowSplashAd
{
    if (self.splashAd&&self.splashAd.splashView.isAdValid) return;
    
    CGRect frame = [UIScreen mainScreen].bounds;

    self.startTime = CACurrentMediaTime();
    
    BUSplashAd *splashAd = [[BUSplashAd alloc] initWithSlotID:k_express_splash_ID adSize:frame.size];
    splashAd.supportCardView = YES;
    splashAd.supportZoomOutView = YES;
    
    // 不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。
    splashAd.delegate = self;
    splashAd.cardDelegate = self;
    splashAd.zoomOutDelegate = self;
    splashAd.tolerateTimeout = 3;
    /***
    广告加载成功的时候，会立即渲染WKWebView。
    如果想预加载的话，建议一次最多预加载三个广告，如果超过3个会很大概率导致WKWebview渲染失败。
    */
    self.splashAd = splashAd;
    [self.splashAd loadAdData];
}

- (void)splashAdLoadSuccess:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);
    AppDelegate *appaDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [splashAd showSplashViewInRootViewController:appaDelegate.window.rootViewController];
}

/// This method is called when material load failed
- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error{
    NSLog(@"splash_%@",error);

}


/// This method is called when splash view render failed
- (void)splashAdRenderFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error{
    NSLog(@"splash_%s",__func__);

}
/// This method is called when splash view render successful
- (void)splashAdRenderSuccess:(BUSplashAd *)splashAd{
    NSLog(@"splash_%s",__func__);
}

/// This method is called when splash view will show
- (void)splashAdWillShow:(BUSplashAd *)splashAd{
    NSLog(@"splash_%s",__func__);

}


/// This method is called when splash view did show
- (void)splashAdDidShow:(BUSplashAd *)splashAd{
    NSLog(@"splash_%s",__func__);

}


/// This method is called when splash view is clicked.
- (void)splashAdDidClick:(BUSplashAd *)splashAd{
    NSLog(@"splash_%s",__func__);

}


/// This method is called when splash view is closed.
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType{
    NSLog(@"splash_%s",__func__);

}


/// This method is called when splash viewControllr is closed.
- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd{
    NSLog(@"splash_%s",__func__);
    self.splashAd = nil;
}


/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashDidCloseOtherController:(BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType{
    NSLog(@"splash_%s",__func__);

}


/// This method is called when when video ad play completed or an error occurred.
- (void)splashVideoAdDidPlayFinish:(BUSplashAd *)splashAd didFailWithError:(NSError *)error{
    NSLog(@"splash_%s",__func__);

}

- (void)splashCardReadyToShow:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);

}

- (void)splashCardViewDidClick:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);

}

- (void)splashCardViewDidClose:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);

}

- (void)splashZoomOutReadyToShow:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);

}

- (void)splashZoomOutViewDidClick:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);

}

- (void)splashZoomOutViewDidClose:(nonnull BUSplashAd *)splashAd {
    NSLog(@"splash_%s",__func__);

}

@end
