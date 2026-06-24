//
//  TWSpeechSynthesisManager.h
//  TaoWu
//
//  Created by JJK on 2023/12/6.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NLSPlayAudio.h"
#import "NuiSdkUtils.h"
#import <nuisdk/NeoNui.h>
#import <nuisdk/NeoNuiTts.h>

NS_ASSUME_NONNULL_BEGIN


@interface TWSpeechSynthesisManager : NSObject

@property(nonatomic, strong) NeoNuiTts *tw_nui;
@property(nonatomic, strong) NLSPlayAudio *tw_voicePlayer;
@property(nonatomic, strong) NuiSdkUtils *tw_utils;

/// 设置声音类型
@property (nonatomic, copy) NSString *font_name;


/// 语音播放完成
@property (nonatomic, strong) void(^voiceSpeedplayDoneBlock)(void);


+ (instancetype)sharedManager;

/**
 初始化
 */
- (void)initNuiTts;

/**
 播放语音内容
 */
- (void)tw_playerVoice:(NSString *)content;

/**
 停止语音播报
 */
- (void)tw_stopPlayerVoice;

@end

NS_ASSUME_NONNULL_END
