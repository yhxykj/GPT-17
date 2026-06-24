//
//  AppDelegate.m
//  TaoWu
//
//  Created by JJK on 2023/12/4.
//

#import "AppDelegate.h"
#import "AliYunLoginManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    [self.window makeKeyWindow];
    
    IQKeyboardManager.sharedManager.enable = true;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = true;
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    [TWGlobalVC.shared setKeywindow:self.window];
    
    [TWGlobalVC.shared twAaction_setRootViewController];
    
    [TWGlobalVC.shared tw_detectingNetworkStatus];
    
   // lipo /Users/apple/Desktop/TaoWu/TaoWu/nuisdk.framework/nuisdk -remove x86_64 -output /Users/apple/Desktop/TaoWu/TaoWu/nuisdk.framework/nuisdk

    
//    [BUDAdManager setupBUAdSDK:^(BOOL success) {
//        if (success) {
//            [TTSplashAd.shareInstance ShowSplashAd];
//        }
//    }];
    [self _aliComAuth];
    return YES;
}

- (void)_aliComAuth {
    //AliComAuth
    /**
     *  设置 ATAuthSDK 的秘钥信息
     *  建议该信息维护在自己服务器端
     *  放在程序入口处调用效果最佳
     *
     *  1. 首先会从本地沙盒中找
     *  2. 沙盒找不到使用本地最初的秘钥进行初始化
     *  3. 同时发送异步请求从服务端拉取最新秘钥，拉取成功更新到本地沙盒中
     */
//    NSString *authSDKInfo = [[NSUserDefaults standardUserDefaults] objectForKey:PNSATAUTHSDKINFOKEY];
//    if (!authSDKInfo || authSDKInfo.length == 0) {
//        authSDKInfo = PNSATAUTHSDKINFO;
//    }
//    [AliYunLoginManager requestATAuthSDKInfo:^(BOOL isSuccess, NSString * _Nonnull authSDKInfo) {
//        if (isSuccess) {
//            [[NSUserDefaults standardUserDefaults] setObject:authSDKInfo forKey:PNSATAUTHSDKINFOKEY];
//        }
//    }];
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:@"40qSsKF7EatCDiqX5uASI37v/LnKyIsN80i9u7O1FTz/3b1vgjsHqr9IdavZ9vogw1a7H27V6XlGmlRlpuCT9Cg5+9juk/lyhNlDz15H++vv7rLSFD1xxLDD2dQryaCgZ45WWULbmOF/Uh0DDYL+MtuNLQyzbXkJAEzLpdon+DIbCLyrACYHMuN3sWvZPTlMnjh7of5vdQHpu4TUE3mwoflGZn6SpHauWPRpnu3BMT005Cwcw3px/V0G/olYRelr9skjQPwEyaOVRF202oMDtg=="
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"设置秘钥结果：%@", resultDic);
    }];
}


- (UIWindow *)window {
    return _window?:({
        _window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
        _window.backgroundColor = UIColor.whiteColor;
        _window;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [self checkIfVIP:^(BOOL isVIP) {
//        if (isVIP == NO && [UserDefaults.standard boolForKey:@"switchADisActive"] == NO) {
//            [[TTSplashAd shareInstance] show];
//        }
//    }];
    
//    if ([[SAVE_UDF objectForKey:@"vipStatus"] intValue] != 1) {
//
//    }
//
//    [[TTSplashAd shareInstance] ShowSplashAd];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (@available(iOS 14.0, *)) {
//        // iOS 14及以上版本请求权限
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
//                NSString *adID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//                NSLog(@"%@", adID);
//            }
//        }];
//    }
}


@end
