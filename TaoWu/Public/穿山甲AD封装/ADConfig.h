//
//  ADConfig.h
//  YLEarthQuake
//
//  Created by lx on 2023/3/22.
//

#ifndef ADConfig_h
#define ADConfig_h

#import "BUDAdManager.h"
#import "TTSplashAd.h"
#import <BUAdSDK/BUAdSDK.h>


#if DEBUG
#define k_ad_appKey                   @"5462387"
#define k_express_splash_ID           @"888782092"
#else
#define k_ad_appKey                   @"5462387"
#define k_express_splash_ID           @"888782092"
#endif

#endif /* ADConfig_h */
