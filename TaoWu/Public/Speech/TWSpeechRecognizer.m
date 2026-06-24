//
//  TWSpeechRecognizer.m
//  TaoWu
//
//  Created by JJK on 2023/12/11.
//

#import "TWSpeechRecognizer.h"
#import <Speech/Speech.h>

@interface TWSpeechRecognizer ()<SFSpeechRecognizerDelegate>
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, assign) BOOL recognizerStatus;

@property (nonatomic, strong) NSTimer *tw_timer;

@end

@implementation TWSpeechRecognizer

//+ (TWSpeechRecognizer *)recognizer {
//
//    static TWSpeechRecognizer *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[TWSpeechRecognizer alloc] init];
//    });
//
//    return instance;
//}

- (void)initSpeechRecognizer {
    _audioEngine = [[AVAudioEngine alloc] init];
    _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    _speechRecognizer.delegate = self;
    
    // 请求语音识别权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                NSLog(@"已授权语音识别");
            } else {
                NSLog(@"用户未授权语音识别");
                 // 根据需要进行错误处理
            }
        });
    }];
    
    self.recognizerStatus = NO;
}

// 开始语音识别任务
- (void)tw_speechAudioBufferRecognitionRequest {
    // 检查系统是否支持语音识别
//    if (![SFSpeechRecognizer isSupported]) {
//        NSLog(@"系统不支持语音识别");
//        return;
//    }
    
    [_audioEngine stop];
    [_audioEngine reset];
    
    // 检查语音识别是否可用
    if (_speechRecognizer.isAvailable) {
        // 创建一个音频会话
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error = nil;
        [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
        if (error) {
            NSLog(@"设置音频会话错误：%@", error.localizedDescription);
        }
        
        // 为语音识别创建请求
        _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        AVAudioInputNode *inputNode = _audioEngine.inputNode;
        if (!_recognitionRequest || !inputNode) {
            NSLog(@"语音识别请求创建失败");
            return;
        }
        _recognitionRequest.shouldReportPartialResults = YES;
        
        WS(weakSelf)
        // 开始语音识别任务
        _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (result) {
                // 识别结果
                
                NSLog(@"语音识别结果：%@", result.bestTranscription.formattedString);
                
                [weakSelf _createTimer];
                
                if (weakSelf.recognizerStatus) {
//                    NSLog(@"语音识别结果：%@", result.bestTranscription.formattedString);
                    
                    if (weakSelf.recognizerCompleteBlock) {
                        weakSelf.recognizerCompleteBlock(result.bestTranscription.formattedString);
                    }
                }
                
            } else if (error) {
                // 处理错误
                NSLog(@"语音识别错误：%@", error.localizedDescription);
                
                if (weakSelf.recognizerFailBlock) {
                    weakSelf.recognizerFailBlock();
                }
            }
        }];
        
        // 开始音频引擎
        AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
        [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }];
        
        [_audioEngine prepare];
        NSError *startError = nil;
        [_audioEngine startAndReturnError:&startError];
        if (startError) {
            NSLog(@"音频引擎启动错误：%@", startError.localizedDescription);
            
        } else {
            NSLog(@"开始语音识别");
        }
    } else {
        NSLog(@"语音识别不可用");
    }
}

- (void)tw_stopSpeechRecognition {
    // 停止语音识别
    self.recognizerStatus = YES;
    [_audioEngine stop];
    [_recognitionRequest endAudio];
    _recognitionRequest = nil;
    _recognitionTask = nil;
    
    NSLog(@"停止语音识别");
    
    if (self.recognizerStopBlock) {
        self.recognizerStopBlock();
    }
}

#pragma mark - SFSpeechRecognizerDelegate

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    if (available) {
        NSLog(@"语音识别可用");
    } else {
        NSLog(@"语音识别不可用");
    }
}


- (void)_createTimer {
    [self _stopTimer];
    self.tw_timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(endOfRecording) userInfo:nil repeats:YES];
}

- (void)endOfRecording {
    [self tw_stopSpeechRecognition];
    [self.tw_timer invalidate];
    self.tw_timer = nil;
}

- (void)_stopTimer {
    [self.tw_timer invalidate];
    self.tw_timer = nil;
}


@end
