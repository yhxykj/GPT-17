//
//  TWSpeechRecognizer.h
//  TaoWu
//
//  Created by JJK on 2023/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWSpeechRecognizer : NSObject

//+ (TWSpeechRecognizer *)recognizer;

/**
 初始化语音识别
 */
- (void)initSpeechRecognizer;

/**
 开始语音识别任务
 */
- (void)tw_speechAudioBufferRecognitionRequest;

/**
 结束语音识别任务
 */
- (void)tw_stopSpeechRecognition;


/**
 语音识别完成
 */
@property (nonatomic, strong) void(^recognizerCompleteBlock)(NSString *content);

@property (nonatomic, strong) void(^recognizerFailBlock)(void);

@property (nonatomic, strong) void(^recognizerStopBlock)(void);

@end

NS_ASSUME_NONNULL_END
