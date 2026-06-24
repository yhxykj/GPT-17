//
//  BUAdManager.h
//  BUDemo
//
//  Created by carlliu on 2017/7/27.
//  Copyright © 2017年 chenren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDKConfiguration.h>

@interface BUDPrivacyProvider : NSObject<BUAdSDKPrivacyProvider>

@end

@interface BUDAdManager : NSObject

+ (void)setupBUAdSDK:(void(^)(BOOL success))successBlock;
+ (void)requestTrackingAuthorization;

@end
