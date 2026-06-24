//
//  BUDAdManager.m
//  BUDemo
//
//  Created by carlliu on 2017/7/27.
//  Copyright © 2017年 chenren. All rights reserved.
//

#import "BUDAdManager.h"
#import "ADConfig.h"
#import <AppTrackingTransparency/ATTrackingManager.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation BUDPrivacyProvider

- (BOOL)canUseLocation {
    return YES;
}

- (CLLocationDegrees)latitude {
    return 40;
}

- (CLLocationDegrees)longitude {
    return 120;
}

@end


@implementation BUDAdManager

+ (void)setupBUAdSDK:(void(^)(BOOL success))successBlock {
    
    [self requestTrackingAuthorization];

    BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
    configuration.appID = k_ad_appKey;
    configuration.secretKey = @"0FB5A80D4F2A40DF964CE62AB4C12273";
    // 设置日志输出
    configuration.debugLog = @(1);
    configuration.privacyProvider = [[BUDPrivacyProvider alloc] init];
    [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
        successBlock(success);
    }];
    
}
+ (void)requestTrackingAuthorization{
    
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
            } else {
                NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
            }
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}
@end
