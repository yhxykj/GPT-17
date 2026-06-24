//
//  TTSplashAd.h
//  MeditationTemple
//
//  Created by YUANMAX on 2022/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTSplashAd : NSObject

+ (instancetype)shareInstance;

-(void) ShowSplashAd; // 单例调用此代码，一句代码加载广告

@end

NS_ASSUME_NONNULL_END
